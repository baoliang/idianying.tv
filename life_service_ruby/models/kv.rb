#!/usr/bin/ruby
require "../life_service_ruby/models/life_models.rb"
require 'activerecord-postgres-hstore'

class Kv < LifeModelsBase
	serialize :data, ActiveRecord::Coders::Hstore

	def self.get(key)
		record = Kv.where("data ? '#{key}'").first()
		record ? record.data[key] : nil
	end


	def self.put(key, value)
	  record = Kv.where("data ? '#{key}'").first()
	  if record
	  	record.data[key] = value
			record.save()
	  else
	  	Kv.create(:data=>{key=> value})
	  end
	end

	def self.del(key)
		data = self.get(key)
		Kv.delete_all("data ? '#{key}'") if data
	end

end

