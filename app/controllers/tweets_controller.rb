class TweetsController < ApplicationController

  def newest
    @tweets = Tweet.limit(33).all

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
    

  # GET /tweets/1
  # GET /tweets/1.xml
  def show
    @tweet = Tweet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tweet }
    end
  end

end
