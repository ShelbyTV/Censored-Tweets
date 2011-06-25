class Tweet
  include MongoMapper::Document
  
  one :twitter_status
  
  key :tweeter
  key :tweeters_follower_count,           Integer, :default => 0
  key :censored_tweeter
  key :censored_tweeters_follower_count,  Integer, :default => 0

  key :points,                            Integer, :default => 0
  key :points_all_time,                   Integer, :default => 0
  
  key :voter_user_ids,                    Array, :typecast => 'ObjectId'
  
  timestamps!
  
  before_save(:on => :create) { self.initialize_points if self.new? }
  
  scope :todays_best, sort(:points => -1)
  scope :newest, sort("twitter_status.status_created_at" => -1)
  
  def self.two_random_tweets
    tweets = Tweet.where(:created_at => {"$gt" => Time.zone.now - 36.hours}).limit(10).all
    id1 = rand(tweets.size)
    id2 = rand(tweets.size) until id2 != id1 and id2 != nil
    return tweets[id1], tweets[id2]
  end
  
  def initialize_points
    self.points = self.points_all_time = self.tweeters_follower_count + self.censored_tweeters_follower_count
    
    User.add_points_to_user_by_uid(self.tweeter["id_str"], self.points)
  end
  
  def upvote(voter)
    self.voter_user_ids << voter.id
    
    points_to_add = (voter.points / 3.33).round
    
    self.points += points_to_add
    self.points_all_time += points_to_add
    
    User.add_points_to_user_by_uid(self.tweeter["id_str"], points_to_add)
  end
  
  
end