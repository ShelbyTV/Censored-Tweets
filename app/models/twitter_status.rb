class TwitterStatus
  include MongoMapper::EmbeddedDocument
  plugin MongoMapper::Plugins::Timestamps

  embedded_in :Tweet
  
  #tweet top level
  key :tweet_id,                Integer
  key :in_reply_to_user_id_str, String
  key :text,                    String
  key :retweeted,               Boolean
  key :retweet_count,           Integer
  key :place,                   String
  key :in_reply_to_status_id,   Integer
  key :source,                  String
  key :id_str,                  String
  key :in_reply_to_user_id,     Integer
  key :truncated,               Boolean
  key :geo,                     Array     # [lat, lng]
  key :favorited,               Boolean
  key :in_reply_to_status_id_str, String
  key :contributors,            String
  key :coordinates,             Array     # [lat, lng]
  key :in_reply_to_screen_name, String
  key :status_created_at,       Time
  
  #user object within tweet
  key :user_description,        String
  key :user_id_str,             String
  key :user_location,           String
  key :user_profile_image_url,  String
  key :user_screen_name,        String
  key :user_name,               String
  
  timestamps!

  validates_presence_of :tweet_id
  

  def self.build_from_grackle(s)
    raise ArgumentError, "Must provide Grackle::TwitterStruct status object" unless s and s.is_a? Grackle::TwitterStruct
    
    TwitterStatus.new({
      #Tweet top level
      :tweet_id => s.id,
      :in_reply_to_user_id_str => s.in_reply_to_user_id_str,
      :text => s.text,
      :retweeted => s.retweeted,
      :retweet_count => s.retweet_count,
      :place => s.place,
      :in_reply_to_status_id => s.in_reply_to_status_id,
      :source => s.source,
      :id_str => s.id_str,
      :in_reply_to_user_id => s.in_reply_to_user_id,
      :truncated => s.truncated,
      :geo => (s.geo ? s.geo.coordinates : nil),
      :favorited => s.favorited,
      :in_reply_to_status_id_str => s.in_reply_to_status_id_str,
      :contributors => s.contributors,
      :coordinates => (s.coordinates ? s.coordinates.coordinates : nil),
      :in_reply_to_screen_name => s.in_reply_to_screen_name,
      :status_created_at => Time.parse(s.created_at),
      
      #User Object
      :user_description => s.user.description,
      :user_id_str => s.user.id,
      :user_location => s.user.location,
      :user_profile_image_url => s.user.profile_image_url,
      :user_screen_name => s.user.screen_name,
      :user_name => s.user.name
      
      #TODO include any other info from twitter status?
    })
  end
  
end
