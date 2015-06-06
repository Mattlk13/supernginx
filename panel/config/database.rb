MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)

case Padrino.env
  when :development then MongoMapper.database = 'panel_development'
  when :production  then MongoMapper.database = 'panel_production'
  when :test        then MongoMapper.database = 'panel_test'
end
