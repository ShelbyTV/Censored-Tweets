class TweetProcessor
  
  def self.process_tweets(grackle_tweets, grackle_client=nil)
    grackle_client ||= Grackle::Client.new
    grackle_tweets.each { |gt| process_tweet(gt, grackle_client) }
  end
  
  # Pass a GrackleStruct and a GrackleClient
  def self.process_tweet(gt, c=nil)
    c ||= Grackle::Client.new
    t = Tweet.new
    
    t.twitter_status = TwitterStatus.build_from_grackle(gt)
    
    
    # original tweeter + follower count
    tweeter = c.users.show?(:screen_name => gt.from_user)
    return nil unless tweeter
    t.tweeter = tweeter.as_json["table"]
    t.tweeter[:status] = t.tweeter[:status].as_json
    t.tweeters_follower_count = tweeter.followers_count

    
    # censored tweeter + follower count
    censored_tweeter = censored_username_from(gt.text, c)
    return nil unless censored_tweeter
    t.censored_tweeter = censored_tweeter.as_json["table"]
    t.censored_tweeter[:status] = t.censored_tweeter[:status].as_json
    t.censored_tweeters_follower_count = censored_tweeter.followers_count
    
    
    t.save
    return t
  end
  
  
  def self.censored_username_from(text, c)
    #looking to pull SCREENNAME from
    #    "#censoredtweet RT @SCREENNAME: some other bull shit"
    # or "#censoredtweet RT @SCREENNAME some other bull shit"
    matched = text.match(/RT @(\w*)[:\s]/)
    return nil unless matched and matched.size == 2
    screen_name = matched[1]
    return nil unless screen_name
    c.users.show?(:screen_name => screen_name)
  end
  
  
end