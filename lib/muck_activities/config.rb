module MuckActivities
  
  def self.configuration
    # In case the user doesn't setup a configure block we can always return default settings:
    @configuration ||= Configuration.new
  end
  
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :automatically_activate
    attr_accessor :enable_activity_comments
    attr_accessor :enable_live_activity_updates
    attr_accessor :live_activity_update_interval
    attr_accessor :enable_activity_shares
    attr_accessor :enable_activity_file_uploads
    attr_accessor :enable_activity_image_uploads
    attr_accessor :enable_activity_video_sharing
    
    def initialize
      self.enable_activity_comments = true     # Enable if you would like to enable comments for your project's activities feeds
      self.enable_live_activity_updates = true # Turns on polling inside the user's activity feed so they constantly get updates from the site
      self.live_activity_update_interval = 60  # Time between updates to live activity feed in seconds
                                               # Note that this will poll the server every 60 seconds and so will increase server load and bandwidth usage.
      self.enable_activity_shares = true       # Turn on shares in the activity feed

      # You can also use the 'contribute' helper method to render a richer status update if you have uploader installed and configured:
      self.enable_activity_file_uploads = true # Turn on file uploads in the activity feed.  Requires that uploader be installed.
      self.enable_activity_image_uploads = true # Turn on image uploads in the activity feed.  Requires that uploader and muck_albums be installed.
      self.enable_activity_video_sharing = true # Turn on video sharing in the activity feed.
    end
    
  end
end