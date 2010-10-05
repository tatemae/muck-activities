require File.dirname(__FILE__) + '/../spec_helper'

class Muck::ActivitiesControllerTest < ActionController::TestCase

  tests Muck::ActivitiesController

  describe "activities controller - anonymous" do
    describe "on GET to index" do
      before do
        @user = Factory(:user)
        @activity = Factory(:activity, :template => 'status_update')
        @user.activities << @activity
      end
      describe "on GET to index (js)" do
        before do
          get :index, :parent_type => @user.class, :parent_id => @user, :format => 'js', :latest_activity_id => @activity.to_param
        end
        it { should respond_with :success }
      end
    end
  end
  
  describe "activities controller - logged in" do
    before do
      activate_authlogic
      @user = Factory(:user)
      login_as @user
    end

    describe "on GET to index" do
      before do
        @activity = Factory(:activity, :template => 'status_update')
        @user.activities << @activity
      end
    
      describe "on GET to index (js)" do
        before do
          get :index, :parent_type => @user.class, :parent_id => @user, :format => 'js', :latest_activity_id => @activity.to_param
        end
        it { should respond_with :success }
      end

      describe "on GET to index (js) no latest activity id" do
        before do
          get :index, :parent_type => @user.class, :parent_id => @user, :format => 'js', :latest_activity_id => nil
        end
        it { should respond_with :success }
      end
    end

    describe "fail on POST to create (json)" do
      before do
        post :create, :activity => { :content => 'test activity' }, :parent_type => @user.class.to_s, :parent_id => @user, :format => 'json'
      end      
      it { should respond_with :success }
      it { should_not set_the_flash }
      it "should return create json errors" do
        json = ActiveSupport::JSON.decode(@response.body).symbolize_keys!
        json[:success].should be_false
        json[:message].should == I18n.t("muck.activities.create_error", :error => assigns(:activity).errors.full_messages.to_sentence)
      end
    end
        
    describe "on POST to create (json)" do
      before do
        @activity_content = 'test content for my new activity'
        post :create, :activity => { :content => @activity_content, :template => 'status_update' }, :parent_type => @user.class, :parent_id => @user, :format => 'json'
      end      
      it { should respond_with :success }
      it { should_not set_the_flash }
      it "should return valid create json" do
        json = ActiveSupport::JSON.decode(@response.body).symbolize_keys!
        json[:success].should be_true
        json[:is_status_update].should be_false
        json[:html].should include(@activity_content)
        I18n.t("muck.activities.created").should == json[:message]
      end
    end
       
    describe "on POST to create (js)" do
      before do
        post :create, :activity => { :content => 'test activity' }, :parent_type => @user.class, :parent_id => @user, :format => 'js'
      end      
      it { should respond_with :success }
      it { should_not set_the_flash }
    end
     
    describe "on POST to create" do
      before do
        post :create, :activity => { :content => 'test activity' }, :parent_type => @user.class, :parent_id => @user
      end      
      it { should redirect_to( @user ) }
    end

    describe "on DELETE to destroy" do
      before do
        @activity = Factory(:activity, :source => @user)
        delete :destroy, :id => @activity.id
      end
      should_respond_with :redirect
      should_set_the_flash_to(I18n.t("muck.activities.item_removed"))
    end
  
    describe "on DELETE to destroy (js)" do
      before do
        @activity = Factory(:activity, :source => @user, :is_status_update => false)
        delete :destroy, :id => @activity.id, :format => 'js'
      end
      it { should respond_with :success }
      it { should_not set_the_flash }
    end
    
    describe "on DELETE to destroy, status update (js)" do
      before do
        @activity = Factory(:activity, :source => @user, :is_status_update => true)
        delete :destroy, :id => @activity.id, :format => 'js'
      end
      it { should respond_with :success }
      it { should_not set_the_flash }
    end
    
    describe "on DELETE to destroy (json)" do
      before do
        @activity = Factory(:activity, :source => @user, :is_status_update => false)
        delete :destroy, :id => @activity.id, :format => 'json'
      end
      it { should respond_with :success }
      it { should_not set_the_flash }
      it "should return valid delete json" do
        json = ActiveSupport::JSON.decode(@response.body).symbolize_keys!
        json[:success].should be_true
        json[:is_status_update].should be_false
        json[:html].should be_blank
        I18n.t("muck.activities.item_removed").should == json[:message]
      end
    end
    
    describe "on DELETE to destroy, status update (json)" do
      before do
        @activity = Factory(:activity, :source => @user, :is_status_update => true)
        delete :destroy, :id => @activity.id, :format => 'json'
      end
      it { should respond_with :success }
      it { should_not set_the_flash }
      it "should return valid delete json" do
        json = ActiveSupport::JSON.decode(@response.body).symbolize_keys!
        json[:success].should be_true
        json[:is_status_update].should be_true
        json[:html].length.should > 0
        I18n.t("muck.activities.item_removed").should == json[:message]
      end
    end
  end
  
end
