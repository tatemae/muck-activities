# using muck shares to test MuckActivities::Models::ActivityItem

require File.dirname(__FILE__) + '/../spec_helper'

class ShareTest < ActiveSupport::TestCase
  describe "share" do
    before do
      @user = Factory(:user)
      @share = Factory(:share)
      @share.add_share_activity([@user])
    end
    subject { @share }
    it { should have_many :activities }
    it "shoulddelete activities if share is deleted" do
      assert_difference "Activity.count", -1 do
        @share.destroy
      end
    end
  end
end