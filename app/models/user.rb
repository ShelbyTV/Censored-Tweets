class User
  include MongoMapper::Document

  devise  :rememberable, :trackable
  
  key :remember_me,           Boolean, :default => true
  key :remember_token,        String

  # oAuth
  key :provider,      String
  key :uid,           String
  key :oauth_token,   String
  key :oauth_secret,  String
  
  # oAuth user info
  key :name,        String
  key :nickname,    String
  key :email,       String
  key :first_name,  String
  key :last_name,   String
  key :location,    String
  key :description, String
  key :image,       String
  key :large_image, String
  key :phone,       String
  key :urls,        String
  key :user_hash,   String
  key :gender,      String
  key :timezone,    String
  
  timestamps!


  def self.build_from_omniauth(omniauth)
    raise ArgumentError, "Must have credentials and user info" unless (omniauth.has_key?('credentials') and omniauth.has_key?('user_info'))
    
    user = User.new(
      :provider => omniauth['provider'],
      :uid => omniauth['uid'],
      :name => omniauth['user_info']['name'])
      
    #Optional credentials
    if omniauth['credentials']
      user.oauth_token = omniauth['credentials']['token']
      user.oauth_secret = omniauth['credentials']['secret'] if omniauth['credentials']['secret']
    end
      
    # Optional user info
    user.nickname = omniauth['user_info']['nickname'] if omniauth['user_info']['nickname']
    user.email = omniauth['user_info']['email'] if omniauth['user_info']['email']
    user.first_name = omniauth['user_info']['first_name'] if omniauth['user_info']['first_name']
    user.last_name = omniauth['user_info']['last_name'] if omniauth['user_info']['last_name']
    user.location = omniauth['user_info']['location'] if omniauth['user_info']['location']
    user.description = omniauth['user_info']['description'] if omniauth['user_info']['description']
    user.image = omniauth['user_info']['image'] if omniauth['user_info']['image']
    user.phone = omniauth['user_info']['phone'] if omniauth['user_info']['phone']
    user.urls = omniauth['user_info']['urls'] if omniauth['user_info']['urls']
   
    # Extra user hash (from services like twitter)
    if omniauth['extra']
      user.user_hash = omniauth['extra']['user_hash'] if omniauth['extra']['user_hash']
    end
    
    # Bigger Image Hack
    #If auth is twitter, we can try removing the _normal before the extension of the image to get the large version...
    if !user.image.blank? and !user.image.include?("default_profile")
      user.large_image = user.image.gsub("_normal", "")
    end
    
    return user
  end
  
  def update_oauth_tokens!(omniauth)
    if oauth_token != omniauth['credentials']['token'] or oauth_secret != omniauth['credentials']['secret']
      update_attributes!({ :oauth_token => omniauth['credentials']['token'], :oauth_secret => omniauth['credentials']['secret'] })
    end
    return self
  end

end
