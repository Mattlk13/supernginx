class Mail
  include MongoMapper::Document

  # key <name>, <type>
  key :domain, String
  key :name, String
  key :password, String
  key :alias, String
  timestamps!
end
