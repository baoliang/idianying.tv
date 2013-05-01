#!/usr/bin/ruby
#encoding=utf-8
require "../life_service_ruby/models/life_models.rb"
require 'digest/sha1'

class User < LifeModelsBase
  ["email", "name"].each do |name|
    self.send :define_method, "check_#{name}_only".to_sym do |value| 
      User.send "find_by_#{name}", "#{value}"
    end
  end
  
  def reg(email, name, pwd)
    return {:has=> "email"} if User.find_by_email email
    return {:has=> "name"} if User.find_by_name name
    return {:has=> "email_valid"} unless email.include? "@"
  	self.email = email
  	self.name = name
  	self.pwd = sha1(pwd.to_s +  pwd.to_s.length.to_s)
    self.save
    self.pwd = nil
    return self

  end

  def sha1(pass)
      Digest::SHA1.hexdigest(pass)
  end  
 

  def login(email, pwd)
    
    User.first(:conditions=> {:email=> email,
                              :pwd=> sha1(pwd.to_s + pwd.length.to_s)
    })
  end
  
  def get_password(email)

  end
  
end
