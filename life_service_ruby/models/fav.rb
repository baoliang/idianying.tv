#!/usr/bin/ruby
#encoding=utf-8
require "../life_service_ruby/models/life_models.rb"
require "time"

class Fav < LifeModelsBase
  def self.add_fav(email, id)
    Fav.create(:email=> email, :move_id=>id, :created_at=>Time.now()) unless Fav.where(:email=> email, :move_id=> id).first 
  end
end
