class Muck::ActivitiesController < ApplicationController
  unloadable
  
  include ApplicationHelper
  include MuckActivityHelper
  
  before_filter :login_required, :except => :index
  before_filter :find_parent, :only => [:index, :create]
  before_filter :get_activity, :only => [:destroy, :comment_html]

  def index
    if @parent.can_view?(current_user)
      @activities = get_activities(@parent)
    else
      @activities = get_profile_activities(@parent) # only items for the profile
    end
    respond_to do |format|
      format.js { render :text => get_activities_html(@activities) }
    end
  end
  
  def create
    @activity = @parent.activities.build(params[:activity])
    @activity.source = @parent
    @activity.content.gsub!(@parent.display_name, '') if @activity.template == 'status_update'
    @parent.save!
    @activity_html = get_activity_html(@activity)
    if @activity.template == 'status_update'
      @status_html = get_status_html(@parent)
    else
      @status_html = ''
    end
    respond_to do |format|
      format.js { render :template => 'activities/create', :layout => false }
      format.html { redirect_back_or_default(@parent) }
      format.json do
        render :json => { :success => true,
                          :is_status_update => @activity.is_status_update,
                          :html => @activity_html,
                          :status_html => @status_html,
                          :message => t("muck.activities.created") }
      end
    end

  rescue ActiveRecord::RecordInvalid => ex

    if @activity
      errors = @activity.errors.full_messages.to_sentence
    else
      errors = ex
    end
    message = t('muck.activities.update_error', :errors => errors)
    respond_to do |format|
      format.html do
        flash[:error] = message
        redirect_back_or_default(@parent)
      end
      format.js { render :js => message }
      format.json do
        render :json => { :success => false,
                          :exception => ex,
                          :message => t("muck.activities.create_error", :error => errors) }
      end
    end

  end

  def destroy
    @activities_object = @activity.source
    @activity.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = t("muck.activities.item_removed")
        redirect_back_or_default(@activities_object)
      end
      format.js do
        @new_status = get_status_html(@activities_object) if @activity.is_status_update
        render :template => 'activities/destroy', :layout => false
      end
      format.json do
        @new_status = get_status_html(@activities_object) if @activity.is_status_update
        render :json => { :success => true,
                          :is_status_update => @activity.is_status_update,
                          :html => @new_status,
                          :message => t("muck.activities.item_removed") }
      end
    end

  rescue => ex
    respond_to do |format|
      format.html do
        flash[:notice] = t("muck.activities.item_could_not_be_removed")
        redirect_back_or_default(current_user)
      end
      format.js { render :text => page_alert(t("muck.activities.item_could_not_be_removed")) }
      format.json { render :json => { :success => false, :message => t("muck.activities.item_could_not_be_removed") } }
    end
  end

  protected
  
  def get_activities_html(activities, limited = false)
    render_as_html do
      render_to_string(:partial => "activities/cached_activities", :locals => {:activities => @activities, :limited => limited})
    end
  end
  
  def get_status_html(activity)
    render_as_html do
      render_to_string(:partial => 'activities/current_status', :locals => {:activities_object => activity})
    end
  end
  
  def get_activity_html(activity)
    render_as_html do
      render_to_string(:partial => "activity_templates/#{activity.template}", :locals => { :activity => activity })
    end
  end
  
  def find_parent
    @klass = params[:parent_type].to_s.capitalize.constantize
    @parent = @klass.find(params[:parent_id])
  end

  def get_activity
    @activity = Activity.find(params[:id])
    unless @activity.can_edit?(current_user)
      respond_to do |format|
        format.html do
          flash[:notice] = t("muck.activities.permission_denied")
          redirect_back_or_default(current_user)
        end
        format.js { render :template => 'activities/permission_denied' }
      end
    end
  end

end