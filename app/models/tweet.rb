class Tweet
  include MongoMapper::Document
  
  one :twitter_status
  
  key :tweeters_follower_count,           Integer
  key :original_tweeters_follower_count,  Integer
  key :points,                            Integer
  
  key :votes_current,                     Integer
  key :votes_all_time,                    Integer
  
  timestamps!
  
end