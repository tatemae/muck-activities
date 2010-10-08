require File.dirname(__FILE__) + '/../spec_helper'

describe Activity do

  before do
    @activity = Factory(:activity)
  end
  
  it { should validate_presence_of :source }
  
  it { should belong_to :item }
  it { should belong_to :source }
  it { should have_many :activity_feeds }
  it { should have_many :comments }
  
  it { should scope_newer_than }
  it { should scope_older_than }
  it { should scope_by_newest }
  it { should scope_by_oldest }
  it { should scope_by_latest }
  it { should scope_is_public }

  describe "named scopes" do
    before do
      @user = Factory(:user)
      @status_activity = Factory(:activity, :template => 'status')
      @other_activity = Factory(:activity, :template => 'other')
      @private_activity = Factory(:activity, :is_public => false)
      @public_activity = Factory(:activity, :is_public => true)
      @item_activity = Factory(:activity, :item => @user)
      @source_activity = Factory(:activity, :source => @user)
    end
    describe "after" do
      #scope :after, lambda { |id| {:conditions => ["activities.id > ?", id] } }
      it "should only find activites after the given id" do
        
      end
    end
    describe "status_updates" do
      before do
        @status_update = Factory(:activity, :item => @user, :is_status_update => true)
        @non_status_update = Factory(:activity, :item => @user, :is_status_update => false)
      end
      it "should find only status updates" do
        Activity.status_updates.should include(@status_update)
        Activity.status_updates.should_not include(@non_status_update)
      end
    end
    describe "filter_by_template" do
      it "should only find status template" do
        activities = Activity.filter_by_template('status')
        activities.should include(@status_activity)
        activities.should_not include(@other_activity)
      end
    end
    describe "by_item" do
      it "should find activities by the item they are associated with" do
        activities = Activity.by_item(@user)
        activities.should include(@item_activity)
        activities.should_not include(@public_activity)
      end
    end
    describe "created_by" do
      it "should find activities by the source they are associated with" do
        activities = Activity.created_by(@user)
        activities.should include(@source_activity)
        activities.should_not include(@public_activity)
      end
    end
  end

  it "should require template or item" do
    activity = Factory.build(:activity, :template => nil, :item => nil)
    activity.should_not be_valid
  end

  it "should get the partial from the template" do
    template = 'status_update'
    activity = Factory(:activity, :template => template, :item => nil)
    activity.partial.should == template
  end

  it "should get the partial from the item" do
    user = Factory(:user)
    activity = Factory(:activity, :item => user, :template => nil)
    activity.partial.should == user.class.name.underscore
  end

  it "should be able to edit the activity" do
    user = Factory(:user)
    activity = Factory(:activity, :source => user)
    activity.can_edit?(user).should be_true
  end
  
  it "should not be able to edit the activity" do
    user = Factory(:user)
    activity = Factory(:activity)
    activity.can_edit?(user).should be_false
  end
  
  it "should filter the activities by template" do
    @template_name = 'test_template'
    user = Factory(:user)
    activity = Factory(:activity, :source => user, :template => @template_name)
    user.activities << activity
    user.activities.filter_by_template(@template_name).should include(activity)
  end
  
  it "should only find activities created by the source" do
    user = Factory(:user)
    activity = Factory(:activity, :source => user, :template => @template_name)
    user.activities << activity
    
    user2 = Factory(:user)
    activity2 = Factory(:activity, :source => user2, :template => @template_name)
    user2.activities << activity2
    
    user.activities.created_by(user).should include(activity)
    user.activities.created_by(user).should_not include(activity2)
  end
  
  describe "comments" do
    before do
      @user = Factory(:user)
      @activity = Factory(:activity)
      @comment = @activity.comments.build(:body => 'a test comment')
      @comment.user = @user
      @comment.save!
    end
    it "should have comments" do
      @activity.comments.length.should == 1
    end
    it "should have comment cache" do
      @activity.reload
      @activity.comment_count.should == 1
    end
  end
  
end 