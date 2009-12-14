require File.dirname(__FILE__) + '/../test_helper'

class ActivityFeedTest < ActiveSupport::TestCase
  context "ActivityFeed" do
    setup do
      @activity_feed = Factory(:activity_feed)
    end
    subject { @activity_feed }
    should_belong_to :activity
    should_belong_to :ownable
  end
end