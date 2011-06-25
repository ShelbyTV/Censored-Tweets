require 'twitter_poller'

class TweetsController < ApplicationController
  before_filter :authenticate_user!, :only => [:upvote]

  def index
    @tweets = Tweet.todays_best.limit(33).all
    @winner = Winner.most_recent.first

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tweets }
    end
  end

  def newest
    @tweets = Tweet.newest.limit(33).all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tweets }
    end
  end
  
  def best
    @tweets = Tweet.todays_best.limit(33).all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tweets }
    end
  end
    
  def upvote
    @tweet = Tweet.find_by_id(params[:id])
    
    @did_vote = (@tweet ? @tweet.upvote!(current_user) : false)
    
    respond_to do |format|
      #TODO: AJAXIFY
      format.html { redirect_to root_path }
      format.xml  { render :xml => @tweets }
    end
  end

  # GET /tweets/1
  # GET /tweets/1.xml
  def show
    @tweet = Tweet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tweet }
    end
  end
  
  def head2head
    @tweets = Tweet.two_random_tweets
    
    respond_to do |format|
      format.html # head2head.html.erb
      format.xml  { render :xml => @tweet }
    end
  end
  
  def poll_twitter
    @new_results = Twitter::Poller.search("#censoredtweet")
  end

end
