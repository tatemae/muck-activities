require File.dirname(__FILE__) + '/../spec_helper'

describe MuckActivityHelper do
  
  before(:each) do
    @user = Factory(:user)
    helper.stub!(:current_user).and_return(@user)
    @activity_with_comments = Factory(:activity)
    @comment1 = Factory(:comment, :commentable => @activity_with_comments)
    @comment2 = Factory(:comment, :commentable => @activity_with_comments)
    @activity_with_comments.reload
    @status_activity = Factory(:activity, :template => 'status_update')
    @status_update_activity = Factory(:activity, :template => 'status_update')
    @user_status_update_activity = Factory(:activity, :template => 'status_update', :source => @user)
    @other_activity = Factory(:activity, :template => 'status_update')
    @private_activity = Factory(:activity, :is_public => false, :template => 'status_update')
    @public_activity = Factory(:activity, :is_public => true, :template => 'status_update')
    @item_activity = Factory(:activity, :item => @user, :template => 'status_update')
    @source_activity = Factory(:activity, :source => @user, :template => 'status_update')
    @other_user_activity = Factory(:activity, :template => 'status_update')
    @user.activities << @status_activity
    @user.activities << @status_update_activity
    @user.activities << @other_activity
    @user.activities << @private_activity
    @user.activities << @public_activity
    @user.activities << @user_status_update_activity
    @user.reload
  end
  describe "activity_comments" do
    it "should render comments for the give activity" do
      helper.activity_comments(@activity_with_comments).should include(@comment1.body)
    end
  end
  describe "activity_comment_link" do
    before do
      @saved_enable_activity_comments = MuckActivities.configuration.enable_activity_comments
      MuckActivities.configuration.enable_activity_comments = true
    end
    after do
      MuckActivities.configuration.enable_activity_comments = @saved_enable_activity_comments
    end
    it "should render comment link" do
      helper.activity_comment_link(@activity_with_comments, @comment1).should include(@activity_with_comments.dom_id)
    end
  end
  describe "activity_scripts" do
    it "should render activity scripts" do
      helper.activity_scripts.should include()
    end
  end
  describe "cached_activities" do
    it "should render cached activities" do
      helper.cached_activities([@status_update_activity]).should_not be_empty
    end
  end
  describe "has_comments_css" do
    it 'renders css with activites' do
      helper.has_comments_css(@activity_with_comments).should == 'activity-has-comments'
    end
    it 'renders css with out activites' do
      helper.has_comments_css(@other_activity).should == 'activity-no-comments'
    end
  end
  describe "limited_activity_feed_for" do
    it "Renders an activity with only activities created by activities_object" do
      helper.limited_activity_feed_for(@user).should include(@user_status_update_activity.dom_id)
      helper.limited_activity_feed_for(@user).should_not include(@other_activity.dom_id)
    end
  end
  describe "activity_feed_for" do
    it "Renders a full activity feed for activities_object" do
      helper.activity_feed_for(@user).should include(@user_status_update_activity.dom_id)
      helper.activity_feed_for(@user).should_not include(@other_user_activity.dom_id)
    end
  end
  describe "status_update" do
    it "should render status update partial" do
      helper.status_update(@status_update_activity).should include('status-update')
    end
  end
end