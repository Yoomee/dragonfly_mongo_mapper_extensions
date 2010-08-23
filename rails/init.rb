begin
  Dragonfly::DataStorage::Base
  has_dragonfly = true
rescue NameError
  has_dragonfly = false
end
require 'dragonfly_mongo_mapper_extensions' if has_dragonfly
