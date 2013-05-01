#!/usr/bin/ruby
#encoding=utf-8
require 'sinatra'
require 'sinatra/synchrony'
require "sinatra/reloader" if development?
require "../life_lib_ruby/tools.rb"
require "../life_service_ruby/life_hander.rb"

include Tools


set :protection, :except => :json_csrf
set :development, :except => :json_csrf
use Rack::Session::Pool, :expire_after => 2592000
set :session_secret, 'wwwsunboy'
success = {:success=> true}.to_json
failed = {:success=> false}.to_json
use Rack::Logger
enable :run
ActiveRecord::Base.logger=Logger.new(STDOUT)
configure do 
  #set :static_url, "/"
  set :static_url, "/static" if development?
  set :env, 'prd'
  set :color, [{b: "#007F00", c:"white"},{c:"#2B2B2B", b:"#F1F1F1"}, {b:"#222", c: "#white"}, {c:"#2B2B2B", b:"#F1F1F1"},{b:"#B52218", c:"white"}, {b:"#D64", c:"white"}, {b:"#F9F0A8", c: "#B52218"}]
  set :static_v, '3'
  set :move_cat, get_config("../life_service_ruby/config.yaml")["cat"]
  set :menus,  get_config("../life_service_ruby/config.yaml")["menu"]

end

#主页
get '/' do 
  page = params.fetch "page", 1
  search  = params.fetch "fuck_g_0f0_w", ""
  type = params["type"]
  seo = "qvod, 百度影音, 快播, 电影, 电视剧, 美剧, 爱电影"
  path  = ""
  params.each do |key, value|
    path += "&#{key}=#{value}"
  end
  sort =  params.fetch 'sort', 'score' 
  session["active"] = "热门" if sort == "score"
  session["active"] = "最新" if sort == "update_time"
  session["active"] = "得分" if sort == "ups"
  session[:path] = path
  two_menu_index = 0 
  two_menu_index = 1 if  params[:one_cat] == '电视剧'  
  moves = LifeHander.new.get_move(page,
                                  type,
                                  sort,
                                  search,
                                  params["one_cat"],
                                  params["two_cat"])

  erb :index, :locals=> {:moves=> moves,
                         :session=> session,
                         :menu=> {session[:menu]=> "active"},
                         :seo => seo,
                         :search=> search,
                         :two_menu_index => two_menu_index}
end

get '/move/fav' do
  page = params.fetch "page", 1
  search  = params.fetch "fuck_g_0f0_w", ""
  type = params["type"]
  seo = "qvod, 百度影音, 快播, 电影, 电视剧, 美剧, 爱电影"

  path  = request.path
  path = "/move/fav?" if path == "/move/fav"
  params.each do |key, value|
    path += "&#{key}=#{value}"
  end
  session[:path] = path
  two_menu_index = 0 
  two_menu_index = 1 if  params[:one_cat] == '电视剧'    
  session["active"] = "收藏"
  moves = LifeHander.new.get_favs(session.fetch("email", ""),
                                  page,
                                  type,
                                  search,
                                  params["one_cat"],
                                  params["two_cat"])

  erb :fav, :locals=> {:moves=> moves,
                         :session=> session,
                         :menu=> {session[:menu]=> "active"},
                         :seo => seo,
                         :search=> search,
                         :two_menu_index => two_menu_index}
end
get '/move/his' do
  page = params.fetch "page", 1
  search  = params.fetch "fuck_g_0f0_w", ""
  type = params["type"]
  seo = "qvod, 百度影音, 快播, 电影, 电视剧, 美剧, 爱电影"

  path  = request.path
  path = "/move/his?" if path == "/move/his"
  params.each do |key, value|
    path += "&#{key}=#{value}"
  end
  session[:path] = path
  two_menu_index = 0 
  two_menu_index = 1 if  params[:one_cat] == '电视剧'  
  session["active"] = '往事'
  moves = LifeHander.new.get_his(session.fetch("email", ""),
                                 page,
                                 type,
                                 search,
                                 params["one_cat"],
                                 params["two_cat"])

  erb :his, :locals=> {:moves=> moves,
                         :session=> session,
                         :menu=> {session[:menu]=> "active"},
                         :seo => seo,
                         :search=> search,
                         :two_menu_index => two_menu_index}
end


get "/move/:id" do

  move = LifeHander.new.get_move_by_id(params[:id], session[:email])
  erb :detail, :locals=> {:move=> move, 
    :menu=> {session["menu"]=> "active"},
    :seo=> "#{move.name},#{move.label}, #{move.director}, #{move.actor}"
    }
end

get "/move/sub_score/:id" do
  content_type :json
  LifeHander.new.move_sub_score(session[:email], params[:id]).to_json

end

get "/move/plus_score/:id" do
  content_type :json
  
  LifeHander.new.move_plus_score(session[:email], params[:id]).to_json

end


get "/test" do
  "helo"  
end

get "/user/:id" do
  content_type :json
  LifeHander.new.get_user_by_id(params[:id])
end

get '/user_reg' do
  content_type :json
  user = LifeHander.new.reg(params[:email],
                          params[:name],
                          params[:pwd])
  return user.to_json if user[:has]
  session[:email] = user.email  if user
  session[:name] = user.name if user 
  user ? user.to_json : failed
end

get '/user_login' do
  content_type :json
  user = LifeHander.new.login(params[:email], params[:pwd])
  session[:email] = user.email  if user
  session[:name] = user.name if user
  user  ? user.to_json : failed
end

get '/logout' do
  session[:email] = nil 
  session[:name] = nil
  redirect to("/")
end

get '/blog' do
  
end

get '/blog/:id' do

end

get '/douban_auth' do
  erb :douban_auth, :locals=> {:menu=> 'all'}
end

#去哈酷抓取资源
get '/admin/get_haku_data' do
  content_type :text
  LifeHander.new.get_haku_data()
end

#重启服务器更新代码
get '/admin/restart_server' do
  system 'git pull origin master'
  system 'sudo killall ruby && sudo nohup  ruby server.rb & '
  redirect '/admin/console'
end

#管理控制台
get '/admin/console' do
  erb :admin, :locals=> {:seo=> ""}
end

#添加播放历史
get '/move/add_history/:id/:index' do

  LifeHander.new.add_history(session[:email], params[:id], params[:index]) if session[:email] 
end


#添加收藏
get '/move/add_fav/:id' do
  content_type :json
  LifeHander.new.add_fav(session[:email], params[:id]).to_json if session[:email] 
end


