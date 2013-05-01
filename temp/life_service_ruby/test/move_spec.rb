#!/usr/bin/ruby
#encoding = utf-8
require "./models/user.rb"
require "../life_lib_ruby/tools.rb"
require "./life_hander.rb"
require "uri"
require "../life_service_ruby/models/gridfs.rb"
require "../life_service_ruby/models/kv.rb"
require '../life_service_ruby/models/fav.rb'
require '../life_service_ruby/models/history.rb'
require 'time'
include Tools
#ActiveRecord::Base.logger=Logger.new(STDOUT)

describe Move do
  it "get moves from db" do
    move = LifeHander.new.get_move(1)
    move[:pages].should > 1
    move[:moves].length.should  == 20
    move[:count].should > 1 
  end
  
end
  
describe  Kv do
  it "Get store by key!" do 
    Kv.put('key', 'test')
    p Kv.get("key")
    Kv.get("key").should ==  'test'
    
  end
end

describe Move do 
  it "给电影加分减分" do
    Move.delete_all(:name=> 'test')

    move = Move.create(:name=>'test', :update_time=> Time.now)
    key  = "jfreeebird@gmail.com"+move.id.to_s
    LifeHander.new.move_plus_score("jfreeebird@gmail.com", move.id)
    Move.find_by_id(move.id).score.should >0
    LifeHander.new.move_sub_score("jfreeebird@gmail.com", move.id)
    Move.find_by_id(move.id).score.should > 0
    Kv.del(key+'plus')
    Kv.del(key+'sub')
    Kv.get(key+'plus').should == nil
    Kv.get(key+'sub').should == nil

  end
end

describe Move do 
  it "get detail moves" do 
    detail  = LifeHander.new.get_move_by_id(55679)
    detail.should_not == nil
    detail = LifeHander.new.get_move_by_id(55679, 'test@gmail.com')
    detail.fav.should == nil

  end
end

describe Fav do 
  it "测试收藏电影" do
    email = 'test@gmail.com' 
    Fav.delete_all(:email=> email )
    fav  = LifeHander.new.add_fav(email, 1)
    Fav.find_by_move_id(1).move_id.should == 1 

  end

  it "测试取得收藏电影" do

    email = 'test@gmail.com'
    Fav.delete_all(:email=> email)
    100.times do |i|
      LifeHander.new.add_fav(email, i)      
    end

    favs  = LifeHander.new.get_favs('test@gmail.com')
    favs[:count] == 5
    Fav.delete_all(:email=> email)
      
  end
end

describe History do 
  it "测试添加播放历史" do
    email = 'test@gmail.com'
    History.delete_all(:email=> email)
    his = LifeHander.new.add_history(email, 1, 1)
    his.index.should == 1
    his = LifeHander.new.add_history(email, 1, 1)
    History.where(:email=> email).count.should == 1
    History.delete_all(:email=> email)
  end
end

