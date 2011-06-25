class AuthenticationsController < ApplicationController  
  #before_filter :authenticate_user!, :only => [:merge_accounts, :do_merge]

  def index

  end

  def create
    omniauth = request.env["omniauth.auth"]
  
    # See if we have a matching user...
    user = User.first( :conditions => { 'provider' => omniauth['provider'], 'uid' => omniauth['uid'] } )
    
    
    if user                    # ---- Current user, just signing in
      # It's possible for authenication tokens to change...
      user.update_authentication_tokens!(omniauth)
      
      # Always remember users, onus is on them to log out
      user.remember_me!
      
      sign_in(:user, user)
      redirect_to request.env['omniauth.origin'] || root_path


    elsif user_signed_in?         # ---- Unusual... we're not adding authentications.  just continue
      redirect_to root_path

      
    else                          # ---- New User signing up!
      user = User.build_from_omniauth(omniauth)

      user.save
      
      sign_in(:user, user)
      redirect_to request.env['omniauth.origin'] || root_path
    end
    
  end
  
  def fail
    redirect_to root_path, :notice => params[:message] || "Sorry, couldn't log you in for some reason, Twitter might not be playing nice.  Please try again in a little bit."
  end
  
end