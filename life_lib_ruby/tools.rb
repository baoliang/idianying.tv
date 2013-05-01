#!/usr/bin/ruby
require "yaml"
YAML::ENGINE.yamler = 'syck'
#Tools Module for this!
module Tools
  
  #Get config by file.
  def get_config config_file
    return YAML::load File.open config_file
  end
  #Get Move name by qvod url
  def get_name_by_url(url, name)
    temp = url.split("|")
      temp = temp[temp.length-2].split(".")[0]
      if temp.split(name).length > 1
        temp.split(name)[1].replace("_", "")  
      else
        return temp
      end
  end  
   
   
end
