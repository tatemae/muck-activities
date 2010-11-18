require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  describe "activities" do
    before do
      @user = Factory(:user)
    end
    it { should have_many :activity_feeds }
    it { should have_many :activities }
    it "should create an activity" do
      lambda {
        @user.add_activity(@user.feed_to, @user, @user, 'status_update', 'status', 'a status update')
      }.should change(Activity, :count)
    end
    it "should set the user's current status" do
      activity = @user.add_activity(@user.feed_to, @user, @user, 'status_update', 'status', 'a status update')
      activity.is_status_update = true
      activity.save!
      activity.should == @user.status
    end
  end
end