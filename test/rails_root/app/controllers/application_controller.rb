class ApplicationController < ActionController::Base
  include SslRequirement
  helper :all
  protect_from_forgery
  
  layout 'default'
  
  protected
  
    # only require ssl if it is turned on
    def ssl_required?
      if GlobalConfig.enable_ssl
        (self.class.read_inheritable_attribute(:ssl_required_actions) || []).include?(action_name.to_sym)
      else
        false
      end
    end
    
end
