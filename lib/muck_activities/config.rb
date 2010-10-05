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
    
    
    def initialize
      self.automatically_activate = true
      # enable_activity_file_uploads: true # Turn on file uploads in the activity feed.  Requires that uploader be installed.
      #   enable_activity_image_uploads: true # Turn on image uploads in the activity feed.  Requires that uploader and muck_albums be installed.
      #   enable_activity_video_sharing: true # Turn on video sharing in the activity feed.
      #
    end
    
  end
end