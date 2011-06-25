MongoMapper.connection = Mongo::Connection.new(
  APP_CONFIG[:mongo_server], 
  APP_CONFIG[:mongo_port], 
  :pool_size => APP_CONFIG[:mongo_pool_size])
MongoMapper.database = APP_CONFIG[:mongo_db_name]

if APP_CONFIG[:mongo_username] && APP_CONFIG[:mongo_password]
  MongoMapper.database.authenticate(APP_CONFIG[:mongo_username], APP_CONFIG[:mongo_password])
end

if defined?(PhusionPassenger)
   PhusionPassenger.on_event(:starting_worker_process) do |forked|
     MongoMapper.connection.connect if forked
   end
end

# The following indexes were created manually (in the background)
# ** We are not running these programatically as they can be VERY slow! **
# ** Do not use :index => true in your models **
#
# EXAMPLE  Used by index to get broadcasts for users channel, this needs to be very efficient as it affects loading of the app
# EXAMPLE Broadcast.ensure_index([[:channel_id, 1], [:created_at, -1], [:video_player, 1]], :background => true)
#
