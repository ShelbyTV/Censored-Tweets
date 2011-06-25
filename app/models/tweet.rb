class Tweet
  include MongoMapper::Document
  
  one :twitter_status
  
  key :tweeter
  key :tweeters_follower_count,           Integer, :default => 0
  key :censored_tweeter
  key :censored_tweeters_follower_count,  Integer, :default => 0

  key :points,                            Integer, :default => 0
  key :points_all_time,                   Integer, :default => 0
  
  key :vote_count,                        Integer, :default => 0
  key :voter_user_ids,                    Array, :typecast => 'ObjectId'
  
  timestamps!
  
  before_save(:on => :create) { self.initialize_points if self.new? }
  
  scope :todays_best, sort(:points => -1)
  scope :newest, sort("twitter_status.status_created_at" => -1)
  
  def initialize_points
    self.points = self.points_all_time = self.tweeters_follower_count + self.censored_tweeters_follower_count
    
    User.add_points_to_user_by_uid(self.tweeter["id_str"], self.points)
  end
  
  def upvote!(voter)
    return false if self.voter_user_ids.include? voter.id
    
    self.vote_count += 1
    self.voter_user_ids << voter.id
    
    points_to_add = [(voter.points / 3.33).round, 7].max
    
    self.points += points_to_add
    self.points_all_time += points_to_add
    
    self.save
    
    User.add_points_to_user_by_uid(self.tweeter["id_str"], points_to_add)
  end
  
  
end