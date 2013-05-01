#!/usr/bin/ruby
require "../life_service_ruby/models/life_models.rb"
require "../life_service_ruby/models/kv.rb"
require '../life_lib_ruby/sort.rb'
require 'time'

class Move < LifeModelsBase
  def self.def_op_score(op)
    define_method  (op+"_score").to_sym do |email|
      self.score = 0 unless self.score 
      key  = email+id.to_s+op
      unless Kv.get(key) 
        self.ups = self.ups.to_i + 1 if op == "plus"
        self.downs = self.downs.to_i - 1 if op ==  "sub"
        self.score = Sort.comput_score(self.update_time, self.ups, self.downs)
        self.save
        Kv.put(key, true)
        Kv.del(email+id.to_s+'sub') if op == 'plus'
        Kv.del(email+id.to_s+'plus') if op == 'sub'
      end
      return self  
    end

  end

  def_op_score "plus"
  def_op_score "sub"

end

