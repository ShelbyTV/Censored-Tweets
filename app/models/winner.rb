class Winner
  include MongoMapper::Document
  
  belongs_to :tweet
  
  key :background_image,    String
  key :tweet_points_at_win, Integer
  
  timestamps!
  
  scope :most_recent, sort(:created_at => -1)
  
  def self.declare_winner!
    winning_tweet = Tweet.todays_best.first
    
    # 1) Capture Winner
    w = Winner.new
    w.tweet = winning_tweet
    w.tweet_points_at_win = winning_tweet.points
    w.background_image = "/images/winner_bgs/"+BACKGROUND_IMAGES[2+rand(BACKGROUND_IMAGES.size-2)]
    w.save
    
    # 2) Reset tweets points
    Tweet.collection.update({}, { '$set' => {'points' => 0} }, :multi => true)

    return w
  end
  
  BACKGROUND_IMAGES = Dir.entries("public/images/winner_bgs/")
  
end