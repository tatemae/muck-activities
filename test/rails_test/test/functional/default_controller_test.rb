require File.dirname(__FILE__) + '/../spec_helper'

class DefaultControllerTest < ActionController::TestCase

  tests DefaultController

  describe "default controller" do
    before do
      activate_authlogic
      @user = Factory(:user)      
      login_as @user
    end

    describe "on GET to index" do
      # The default view calls the helpers.  This isn't a great test but
      # it will make sure they don't blow up
      before do
        @user.activities << Factory(:activity,  :template => 'status_update')
        @user.activities << Factory(:activity,  :template => 'status_update')
        get :index
      end
      it { should respond_with :success }
    end

  end

end
