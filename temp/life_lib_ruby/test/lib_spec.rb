#!/usr/bin/ruby
#encoding = utf-8
require "./tools.rb"
require './sort.rb'
require 'time'
include Tools
#Test user logic

describe Tools do
  it "Test get config's rpc host!" do
    rpc_host = get_config("./test.yaml")["server"]["rpc_host"]
    rpc_host.should  == "tcp://127.0.0.1:7000"
    cat = get_config("../life_service_ruby/config.yaml")["cat"]
 
  end
end

describe Sort do 
  it "测试电影分数算法" do
    Sort.comput_score(Time.now, 100, 10).should > 0
    Sort.comput_score(Time.now, nil, nil).should == 0
    Sort.comput_score(Time.now, 10, 100).should > 0 
  end
end
