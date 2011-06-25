require 'tweet_processor'

module Twitter
  class Poller
    
    def self.search(term, ignore_last_known_id=false)
      search_result, client = poll_search(term)
      
      if ignore_last_known_id or TwitterPolling.first(:order => :created_at.desc)
        last_known_tweet_id = TwitterPolling.first(:order => :created_at.desc).latest_id
      else
        last_known_tweet_id = "0"
      end
      
      new_results = []
      search_result.each do |r|
        if r.id_str > last_known_tweet_id
          new_results << r
        end
      end

      TwitterPolling.create(:latest_id => new_results.first.id_str) unless new_results.empty?
      
      # Process and throw them into DB
      TweetProcessor.process_tweets(new_results, client)
      
      return new_results
    end
    
    def self.poll_search(term)
      client = Grackle::Client.new
      search_result = client[:search].search? :q => term
      search_result = search_result.results
      return search_result, client
    end
    
  end
end