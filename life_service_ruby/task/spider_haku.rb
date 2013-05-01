#!/usr/bin/ruby
#encoding: utf-8
require "anemone"
require "uri"
require "../life_service_ruby/models/move.rb"
require "../life_service_ruby/models/lianxuju.rb"
require "../life_service_ruby/models/gridfs.rb"
require "../life_lib_ruby/sort.rb"
require "open-uri"
require "time"

#转码
String.class_eval do 
  def to_utf8
    self.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
  end
end


def get_res url
  Anemone.crawl(url, {:depth_limit => 1}) do |anemone|
    anemone.storage = Anemone::Storage.MongoDB
    anemone.on_every_page do |page|
      begin
        if page.url.host == 'hakuzy.com' and page.url.path.include? "detail"
          
          move_info =  page.doc.search("table")[4].search("table")[0].search("tbody")[0].search("tr")
          
          m_name = move_info[0].text.to_utf8.gsub "影片名称：", ""
          m_obj = Move.find_by_name(m_name)

          move = m_obj
          if not move 
            p 'is this is new'
            move = Move.new   
            move.created_at = Time.now   
          end
          move_info.each do |m|
            m.text.to_utf8
            if m.text.include? "影片名称"
              name = m.text.gsub "影片名称：", ""
              move.name = name
            end

            if m.text.include? "影片版本"
              version = m.text.gsub "影片版本：", ""
              move.version = version
            end

            if m.text.include? "影片演员"
              actor = m.text.gsub "影片演员：", ""
              move.actor = actor
            end
            if m.text.include? "影片导演"
              director = m.text.gsub "影片导演：", ""
              move.director = director
            end
            if m.text.include? "影片类型"
              label = m.text.gsub "影片类型：", ""
              move.label = label
            end
            if m.text.include? "影片语言"
              language = m.text.gsub "影片语言：", ""
              move.language = language
            end
            if m.text.include? "影片地区"
              area = m.text.gsub "影片地区：", ""
              move.area = area
            end
            if m.text.include? "更新时间"
              upload_time = m.text.gsub "更新时间：", ""
              move.upload_time = upload_time
              if upload_time 
                move.update_time = Time.parse(upload_time)
              else
                move.update_time = Time.now
              end
            end
            if m.text.include? "影片状态"
              status = m.text.gsub "影片状态：", ""
              move.status = status
            end
            if m.text.include? "影片状态"
              status = m.text.gsub "影片状态：", ""
              move.status = status
            end
            if m.text.include? "上映日期"
              updated_at = m.text.gsub "上映日期：", ""
              move.updated_at = updated_at
            end
            
            if m.text.include? "\n"
              describe = m.text.gsub "\n", ""
              describe = describe.gsub "\r", ""
              describe = describe.gsub " ", ""
              move.describe = describe
            end
          end

          img = page.doc.search("table")[4].search("img")[0]["src"]
          if not m_obj
            data=open(img){|f|f.read}
            id = Gridfs.new.save_file(img, data).to_s
            move.img_id = id
          end
          move.source_img_url = img
          m_list = page.doc.search("table")[4].search("table")[1].search("tbody")[0].search("tr")
          p_list = []
          m_list.each do |l|
            if not l.text.include? "\n"

              p_list.push(l.text.to_utf8)
            end
          end
        
          move.p_list = p_list.to_json
          if p_list.length > 0  and move.name != nil
            move.score = Sort.comput_score(move.update_time, move.ups, move.downs)
            move.ups = 0 unless move.ups 
            move.dow = 0 unless move.downs
            move.save()
          end
          
        end 
      rescue => err
        p err
      end
    end
  end
end

def run_spider
  100.times do |i|
    get_res("http://hakuzy.com/list/?0-#{i+1}.html")
    
  end
end


run_spider()

