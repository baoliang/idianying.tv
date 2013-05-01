#encoding=utf-8
require 'open-uri'
require 'fiber'
#同步模式
def s_get_url url
  doc = open(url)
  p doc.charset
  p doc.base_uri.host
end

#异步模式
def a_get_url url
  Thread.new do 
    open(url)
    p doc
    p doc.charset
    p doc.base_uri.host
  end

end

list = ['http://www.baidu.com/', 'http://www.qiyi.com/', 'http://www.idianying.tv/']

p '同步模式 开始了'
3.times do  |i|
  a_get_url list[i]
  p i
end

  


