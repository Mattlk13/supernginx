class Domain
  include MongoMapper::Document

  # key <name>, <type>
  key :domain, String
  key :users, String
  key :ip, String
  key :arecord, String
  key :cnames, String
  key :subdomains, String
  key :options, String
  timestamps!
end
