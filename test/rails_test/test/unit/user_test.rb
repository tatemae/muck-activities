require File.dirname(__FILE__) + '/../spec_helper'

class UserTest < ActiveSupport::TestCase
  describe "activities" do
    before do
      @user = Factory(:user)
    end
    subject { @user }
    it { should have_many :activity_feeds }
    it { should have_many :activities }
    it "shouldcreate an activity" do
      assert_difference "Activity.count", 1 do
        @user.add_activity(@user.feed_to, @user, @user, 'status_update', 'status', 'a status update')
      end
    end
    it "should set the user's current status" do
      activity = @user.add_activity(@user.feed_to, @user, @user, 'status_update', 'status', 'a status update')
      activity.is_status_update = true
      activity.save!
      activity.should == @user.status
    end
  end
end