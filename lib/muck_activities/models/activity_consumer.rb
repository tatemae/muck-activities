module MuckActivities
  module Models
    #
    # +MuckActivities::Models::ActivityConsumer+ gives the class it is called on an activity feed and a method called
    # +add_activity+ that can add activities into a feed.  Retrieve activity feed items
    # via object.activities. ie @user.activities.
    module ActivityConsumer
      extend ActiveSupport::Concern
    
      included do        
        has_many :activity_feeds, :as => :ownable
        has_many :activities, :through => :activity_feeds, :order => 'created_at desc'
        include MuckActivities::Models::ActivitySource
      end
    
    end
  end
end
