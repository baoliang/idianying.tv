#!/usr/bin/ruby
require 'active_record'  
require '../life_lib_ruby/tools.rb'


include Tools
  
ActiveRecord::Base.establish_connection(get_config("../life_service_ruby/config.yaml")["PG"])
  
class LifeModelsBase < ActiveRecord::Base   
  self.abstract_class = true 
  
end 
      
