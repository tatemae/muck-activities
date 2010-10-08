# using muck shares to test MuckActivities::Models::MuckActivityItem
require File.dirname(__FILE__) + '/../spec_helper'

describe Share do
  before do
    @user = Factory(:user)
    @share = Factory(:share)
    @share.add_share_activity([@user])
  end
  it { should have_many :activities }
  it "should delete activities if share is deleted" do
    lambda{
      @share.destroy
    }.should change(Activity, :count).by(-1)
  end
end