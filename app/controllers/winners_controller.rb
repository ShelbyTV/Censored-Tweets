class WinnersController < ApplicationController

  # GET /winners
  # GET /winners.xml
  def index
    @winners = Winner.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @winners }
    end
  end

  # GET /winners/1
  # GET /winners/1.xml
  def show
    @winner = Winner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @winner }
    end
  end

end
