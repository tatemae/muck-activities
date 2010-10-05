class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  acts_as_muck_user
  has_muck_profile
  MuckActivities::Models::ActivityConsumer
  acts_as_muck_sharer
  
  def feed_to
    [self]
  end
  
end