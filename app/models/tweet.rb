class Tweet
  include MongoMapper::Document
  
  one :twitter_status
  
  key :tweeter
  key :tweeters_follower_count,           Integer, :default => 0
  key :censored_tweeter
  key :censored_tweeters_follower_count,  Integer, :default => 0
  key :points,                            Integer, :default => 0
  
  key :votes_current,                     Integer, :default => 0
  key :votes_all_time,                    Integer, :default => 0
  
  timestamps!
  
  before_save(:on => :create) { self.calculate_points if self.new? }
  
  scope :todays_best, sort(:points => 1)
  
  def calculate_points
    self.points = self.tweeters_follower_count + self.censored_tweeters_follower_count
  end
  
end