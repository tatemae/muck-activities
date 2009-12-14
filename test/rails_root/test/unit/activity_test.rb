require File.dirname(__FILE__) + '/../test_helper'

class ActivityTest < ActiveSupport::TestCase

  context 'An Activity' do
    setup do
      @activity = Factory(:activity)
    end
    
    subject { @activity }
    
    should_validate_presence_of :source
    
    should_belong_to :item
    should_belong_to :source
    should_have_many :activity_feeds
    should_have_many :comments
    
    should_scope_since
    should_scope_before
    should_scope_newest
    should_scope_oldest
    should_scope_latest
    should_scope_only_public
  end

  context "named scopes" do
    setup do
      @user = Factory(:user)
      @status_activity = Factory(:activity, :template => 'status')
      @other_activity = Factory(:activity, :template => 'other')
      @private_activity = Factory(:activity, :is_public => false)
      @public_activity = Factory(:activity, :is_public => true)
      @item_activity = Factory(:activity, :item => @user)
      @source_activity = Factory(:activity, :source => @user)
    end
    context "after" do
      #named_scope :after, lambda { |id| {:conditions => ["activities.id > ?", id] } }
      should "only find activites after the given id" do
      end
    end
    context "status_updates" do
      #named_scope :status_updates, :conditions => ["activities.is_status_update = ?", true]
      should "find only status updates" do
      end
    end
    context "filter_by_template" do
      should "only find status template" do
        activities = Activity.filter_by_template('status')
        assert activities.include?(@status_activity), "since didn't find status activity"
        assert !activities.include?(@other_activity), "since found other activity"
      end
    end
    context "by_item" do
      should "find activities by the item they are associated with" do
        activities = Activity.by_item(@user)
        assert activities.include?(@item_activity), "by_item didn't find item activity"
        assert !activities.include?(@public_activity), "by_item found public activity"
      end
    end
    context "created_by" do
      should "find activities by the source they are associated with" do
        activities = Activity.created_by(@user)
        assert activities.include?(@source_activity), "created_by didn't find source activity"
        assert !activities.include?(@public_activity), "created_by found public activity"
      end
    end
  end

  should "require template or item" do
    activity = Factory.build(:activity, :template => nil, :item => nil)
    assert !activity.valid?
  end

  should "get the partial from the template" do
    template = 'status_update'
    activity = Factory(:activity, :template => template, :item => nil)
    assert activity.partial == template, "The activity partial was not set to the specified template"
  end

  should "get the partial from the item" do
    user = Factory(:user)
    activity = Factory(:activity, :item => user, :template => nil)
    assert activity.partial == user.class.name.underscore
  end

  should "be able to edit the activity" do
    user = Factory(:user)
    activity = Factory(:activity, :source => user)
    assert activity.can_edit?(user)
  end
  
  should "not be able to edit the activity" do
    user = Factory(:user)
    activity = Factory(:activity)
    assert !activity.can_edit?(user)
  end
  
  should "filter the activities by template" do
    @template_name = 'test_template'
    user = Factory(:user)
    activity = Factory(:activity, :source => user, :template => @template_name)
    user.activities << activity
    assert user.activities.filter_by_template(@template_name).include?(activity)
  end
  
  should "only find activities created by the source" do
    user = Factory(:user)
    activity = Factory(:activity, :source => user, :template => @template_name)
    user.activities << activity
    
    user2 = Factory(:user)
    activity2 = Factory(:activity, :source => user2, :template => @template_name)
    user2.activities << activity2
    
    assert user.activities.created_by(user).include?(activity)
    assert !user.activities.created_by(user).include?(activity2)
    
  end
  
  context "comments" do
    setup do
      @user = Factory(:user)
      @activity = Factory(:activity)
      @comment = @activity.comments.build(:body => 'a test comment')
      @comment.user = @user
      @comment.save!
    end
    should "have comments" do
      assert_equal 1, @activity.comments.length
    end
    should "have comment cache" do
      @activity.reload
      assert_equal 1, @activity.comment_count
    end
  end
  
end 