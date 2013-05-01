#!/usr/bin/ruby
#encoding = utf-8
require "../life_service_ruby/models/user.rb"
require "../life_service_ruby/models/move.rb"
require "../life_service_ruby/models/lianxuju.rb"
require "../life_service_ruby/models/fav.rb"
require "../life_service_ruby/models/history.rb"
require 'active_record'  
#Life service hander 

ActiveRecord::Base.include_root_in_json = false


class LifeHander
  
  def login(email, pwd)
    User.new.login(email, pwd) 
  end
  
  def check_email(email)
    User.new.check_email(email)
  end
  
  def reg(email, name, pwd)
    User.new.reg(email, name, pwd) 
  end
  
  def get_password(email)
    User.new.get_password(email)
  end
  
  def get_password(email)
    User.new.get_password(email)
  end
  
  def get_move(page, type='', sort='score', search='', one_cat='', two_cat='')
    unless ['电影', '电视剧'].include? one_cat
      type = one_cat if one_cat 
      type = two_cat if two_cat 
    else
      type  = two_cat  if two_cat      
    end

    count =  Move.where("
                           name like '%#{search}%' 
                           and label like  '%#{type}%' 

                           ").count()

    {
      :count=> count,
      :moves=> Move.where("
                           name like '%#{search}%' 
                           and label like  '%#{type}%'
                          
                           " ).
      select("id, name, ups, downs, actor,director, label,describe, source_img_url, img_id, score").
      order("#{sort} desc").
               limit(20).offset((page.to_i*20) -20),
      :pages=> count/20+1,
      :page_num=> page

    }
    
  end  

  def get_move_by_id(id, email=nil)
    Move.instance_eval do 
      attr_accessor :fav
      attr_accessor :index
    end
    move = Move.find_by_id(id)
    fav =Fav.where(:email=> email, :move_id=> id).first if email 
    his =History.where(:email=> email, :move_id=> id).first if email
    move.fav = fav
    move.index = his if his
    return move
  end

  def move_plus_score(email, id)
    move = Move.find_by_id(id).plus_score(email)
    {:display_score=> move.ups.to_i - move.downs.to_i,  :score=> move.score}
  end

  def move_sub_score(email, id)
    move = Move.find_by_id(id).sub_score(email)
    {:display_score=> move.ups.to_i - move.downs.to_i, :score=> move.score}
  end

  def add_fav(email, id)
    Fav.add_fav email, id
  end

  def get_favs(email, page=1, type = "", search="", one_cat='', two_cat='')
    unless ['电影', '电视剧'].include? one_cat
      type = one_cat if one_cat 
      type = two_cat if two_cat 
    else
      type  = two_cat  if two_cat      
    end
    query = Fav.joins('LEFT OUTER JOIN moves ON moves.id = favs.move_id').where(
                          "
                          favs.email = '#{email}'
                          and  moves.name like '%#{search}%' 

                           and moves.label like  '%#{type}%' 

                           ").
      select("move_id, name,ups, downs, actor,director,label,describe, source_img_url, img_id, score, favs.created_at")
    {
      :count=> query.count,
      :moves=> query.
               limit(20).offset((page.to_i*20) -20),
      :pages=> query.count/20+1,
      :page_num=> page

    }
  end

  def add_history(email, id, index)
    History.add_his(email, id, index)
  end

  def get_his(email, page=1, type="", search="", one_cat='', two_cat='')
    unless ['电影', '电视剧'].include? one_cat
      type = one_cat if one_cat 
      type = two_cat if two_cat 
    else
      type  = two_cat  if two_cat      
    end
    query = History.joins('LEFT OUTER JOIN moves ON moves.id = histories.move_id').where(
                          "
                          email = '#{email}'
                          and  name like '%#{search}%' 
                           and label like  '%#{type}%' 

                           ").select("move_id, ups, downs, name, actor,director,label,describe, source_img_url, img_id, score, histories.created_at")
    p page
    p (page.to_i*20) -20
    {
      :count=> query.count,
      :moves=> query.order("created_at desc").limit(20).offset((page.to_i*20) -20),
      :pages=> query.count/20+1,
      :page_num=> page

    }
  end

  def get_haku_data
    system "nohup ruby ../life_service_ruby/task/spider_haku.rb &"
  end

end
