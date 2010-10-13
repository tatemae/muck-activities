class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  include MuckUsers::Models::MuckUser
  include MuckProfiles::Models::MuckUser
  include MuckActivities::Models::MuckActivityConsumer
        
  def feed_to
    [self]
  end
  
end