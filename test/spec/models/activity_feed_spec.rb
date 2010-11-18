require File.dirname(__FILE__) + '/../spec_helper'

describe ActivityFeed do
  describe "ActivityFeed" do
    before do
      @activity_feed = Factory(:activity_feed)
    end
    
    it { should belong_to :activity }
    it { should belong_to :ownable }
  end
end