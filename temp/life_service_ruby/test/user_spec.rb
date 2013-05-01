#!/usr/bin/ruby
#encoding=utf-8
require "./models/user.rb"
require "../life_lib_ruby/tools.rb"
require "./life_hander.rb"
require "../life_service_ruby/models/gridfs.rb"
include Tools
require 'digest/sha1'
#Test user logic

describe User do

  it "Judge user's auth!" do

    User.delete_all(:email=> 'test@idianying.tv')
    User.new.reg("test@idianying.tv", "test", "test_pwdo")
    User.new.login("test@idianying.tv", "test_pwdo").should_not == nil
    
    end
end



describe Gridfs do
  it "save img " do
    s_file = File.open("./t.jpg")
    id = Gridfs.new.save_file("test", s_file)
    id.class.should == BSON::ObjectId
    Gridfs.new.get(id).chunk_size.should > 1 
  end
end

describe User do 
  it "Check user email only" do
    User.delete_all(:email=> 'test@idianying.tv')
    User.new.reg 'test@idianying.tv', 'test', 'test_pwd'
    checked = User.new.check_email_only 'test@idianying.tv'
    User.new.login('test@idianying.tv',  'test_pwd').name.should == 'test'
    checked.should_not  == nil
    User.new.reg('test@idianying.tv', 'test', 'test_pwd')[:has].should == "email"
    
    checked = User.new.check_name_only 'test@idianying.tv'

  end
end


