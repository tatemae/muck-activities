require 'muck-activities'
require 'rails'

module MuckActivities
  class Engine < ::Rails::Engine
    
    def muck_name
      'muck-activities'
    end
    
    initializer 'muck-activities.helpers' do
      ActiveSupport.on_load(:action_view) do
        include MuckActivityHelper
      end
    end
    
  end
end