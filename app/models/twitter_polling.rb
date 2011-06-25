class TwitterPolling
  include MongoMapper::Document
  
  key :latest_id, String
  
  timestamps!
  
  
  def self.last_result
    
  end
  
end