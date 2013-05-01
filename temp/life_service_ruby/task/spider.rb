#!/usr/bin/ruby
#encoding: utf-8
require "anemone"
require "uri"
require "./models/move.rb"
require "./models/lianxuju.rb"
require "./models/gridfs.rb"
require "open-uri"


#转码
String.class_eval do 
  def to_utf8
    self.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
  end
end

def get_m_info(page)
  name  = ""
  director = ""         
  actor = ""
  status = ""
  label = ""
  desc = ""
  pic = ""
  type = "" 
  lab = nil
  if page.doc.at("body").inner_html.include? '<div id="zkb">'
    page.doc.search("//div[@id='zkb']").each do |div|
      name = div.search("h1")[0].text
      director =  div.search("li").search("a")[0].text
      div.search("li")[1].search("a").each do |a|
        actor << ", #{a.text}"
      end
      actor[0] = ""
      status = div.search("li")[2].search("span")[0].text
      pic =   page.doc.search("//div[@id='zka']").search("img")[0]["src"]
      label =  div.search("li")[3].text

      page.doc.css("div.commend").each do |com|
      
        desc  = com.search("p")[1].text
      end
      data=open("http://www.kan520.com#{pic}"){|f|f.read}
      Gridfs.new.save_file(pic, data)
      move = Move.where("name LIKE '%#{name}%'").first()
      if label.include?("电视剧") or name.slice /2.+期_/ or label.include?("综艺节目") or label.include?("动漫电影")
        if not move
          move = Move.new(:lab=>lab, :name=> name,:types=> "1",:actor=>actor, :status=>status, :label=> label, :pic=> pic, :director=>director,  :desc=>desc, :updated_at=> Time.now)
          move.save()
        else
          move = Move.find_by_id(move.id)                          
          move.update_attributes(:name=>name)
          move.update_attributes(:types=> "1")
          move.update_attributes(:actor=> actor)
          move.update_attributes(:status=> status)
          move.update_attributes(:label=> label)
          move.update_attributes(:pic=> pic)
          move.update_attributes(:lab=> lab)
          move.update_attributes(:director=> director) 
          move.update_attributes(:desc=> desc)
          move.update_attributes(:updated_at=> Time.now)
          move.save!()
        end
      else
        if not move
          move = Move.new(:lab=>lab, :name=> name,:types=>"0",:actor=>actor, :status=>status, :label=> label, :pic=> pic, :director=>director,  :desc=>desc)
          move.save()
        else
          if move.label == nil  
            move = Move.find_by_id(move.id)                          
            move.update_attributes(:name=>name)
            move.update_attributes(:types=> "0")
            move.update_attributes(:actor=> actor)
            move.update_attributes(:status=> status)
            move.update_attributes(:label=> label)
            move.update_attributes(:pic=> pic)
            move.update_attributes(:lab=> lab)
            move.update_attributes(:director=> director) 
            move.update_attributes(:desc=> desc)
            move.update_attributes(:datetime=> Time.now)
            move.save!()
            
          end

        end
      end
     
    end

  end  
end

def get_detail_info(page)
  if page.doc.at("body").inner_html.include?('<span id="loadplay">')
    name = ""
    url  = ""
    desc = ""
    name = page.doc.at("title").inner_html.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
    page.doc.css("div.juqing").each do |node|
      desc = node.inner_html.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
    end  
    page.doc.xpath("//script").each do |script|
      if script.inner_html.include? "unescape"
        url = URI.unescape(script.inner_html.slice(/\('.+\)/)).slice(/'.+'/)
        url = URI.unescape(url)
      end
      
    end
    type  = page.doc.css("div.commendType").search("a")[0].text

    move_name = name.slice /《.+》/

    move_name = move_name.gsub "《", ""
    move_name = move_name.gsub "》", ""
    move = Move.where("name LIKE '%#{move_name}'").first()
    lianxuju = Lianxuju.where(:name=> name).first()

    if name.slice /第.+集/ or name.slice /2.+期_/ or type == "动漫电影"
      if not lianxuju
        lianxuju = Lianxuju.new(:name=>name, :url=>url) 
        lianxuju.save()
      else
        if url  != lianxuju.url
          lianxuju.url = url
          lianxuju.save()
        end
      end
    else
      if  move
        move = Move.find_by_id(move.id)
        move.update_attributes(:url=>url)
        move.update_attributes(:updated_at =>Time.now)
        move.update_attributes(:label => type)
        if move.url == nil
          p m.url
          p m.name
        end
        move.save()  
      end
    end  
  end
end

Anemone.crawl('http://www.kan520.com/') do |anemone|
  anemone.storage = Anemone::Storage.MongoDB
  anemone.on_every_page do |page|
    begin
      if page.url.host == 'www.kan520.com'
        get_m_info(page)
        get_detail_info(page) 
        
      end 
    rescue => err
      p err
    end
  end
end
