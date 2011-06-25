class TwitterPolling
  include MongoMapper::Document
  
  key :latest_id, String
  
  timestamps!
  
end