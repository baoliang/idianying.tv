#!/usr/bin/ruby
#encoding=utf-8
require "../life_service_ruby/models/life_models.rb"
require "time"

class History < LifeModelsBase

  def self.add_his(email, id, index)
  	his = self.where(:email=> email, :move_id=> id).first()
  	if his
  		his.index = index
  		his.created_at = Time.now
  		his.save
  	else
    	self.create(:email=> email, :move_id=>id, :created_at=> Time.now, :index=>index)  
		end
  end

end
