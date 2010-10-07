# include MuckActivities::Models::MuckActivityItem
module MuckActivities
  module Models
    #
    # +MuckActivities::Models::MuckActivityItem+ gives the class it is called on a method called
    # +add_activity+ that can add activities into a feed.
    # It also setups up the object to be an 'item' in the activity feed.
    # For example if you have a model called 'friend' which serves as an object
    # that will be used as an 'item' in an activity feed, calling MuckActivities::Models::MuckActivityItem
    # will add 'activities' to the friend object so that you can call @friend.activities to
    # retrieve all the activities for which the @friend object is an item.  Deleting the @friend
    # object will destroy all related activites.
    module MuckActivityItem
      extend ActiveSupport::Concern
    
      included do        
        has_many :activities, :as => :item, :dependent => :destroy
        include MuckActivities::Models::MuckActivitySource
      end
     
    end
  end
end