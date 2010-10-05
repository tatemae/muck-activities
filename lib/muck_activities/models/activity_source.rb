module MuckActivities
  module Models
    
    # +ActivitySource+ gives the class it is called on a method called
    # +add_activity+ that can add activities into a feed.
    # This can be applied to models or controllers
    module ActivitySource
    
      # +add_activity+ adds an activity to all activites feeds that belong to the objects found in feed_to.
      # * +feed_to+: an array of objects that have +MuckActivities::Models::ActivityConsumer+ declared on them.  The generated activity
      #   will be pushed into the feed of each of these objects.
      # * +source+: the object that peformed the activity ie a user or group
      # * +item+: an object that will be used to generated the entry in an activity feed
      # * +template+: name of an partial that will be used to generated the entry in the activity feed.  Place
      #   templates in /app/views/activity_templates
      # * +title+: optional title that can be used in the template
      # * +content+: option content that can be used in the template.  Useful for activities that might not have
      #    an item but instead might have a message or other text.
      # * +check_method+: method that will be called on each item in the feed_to array.  If the method evaluates
      #   to false the activity won't be added to the object's activity feed.  An example usage would be
      #   letting users configure which items they want to have in their activity feed.
      # * +attach_to: In addition, to item the activity can be attached to another object.  This can help
      #   improve performance.  For example, each time an 'entry' recieves a new comment a new comment activity is
      #   added to the muck activity feed.  The comments are also rendered alongside the entries. By attaching the
      #   activity directly to the entry it is easy to pull up all related activities.
      def add_activity(feed_to, source, item, template, title = '', content = '', check_method = nil, attach_to = nil)
        if feed_to.is_a?(Array)
          feed_to.flatten!
          feed_to.uniq! # eliminate duplicates from feed_to array
        else
          feed_to = [feed_to]
        end
        activity = Activity.create(:item => item, :source => source, :template => template, :title => title, :content => content, :attachable => attach_to)
        feed_to.each do |ft|
          if check_method
            ft.activities << activity if ft.send(check_method)
          else
            ft.activities << activity
          end
        end
        activity
      end
    
      # +status+ returns the first activity item from the user's activity feed that is a status update.
      # Used for displaying the last status update the user made
      def status
        self.activities.status_updates.newest.first
      end
    
      def can_view?(check_object)
        self == check_object
      end
    end

  end
end