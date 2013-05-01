require "watir-webdriver"
require "nokogiri"
browser = Watir::Browser.new :firefox
browser.goto "http://www.abcam.com/Abscisic-acid-conjugated-antibody-ab36949.html"

p browser.html
#Nokogiri::HTML(browser.html).css("table[id ^= 'availabilityPriceTable']").each do |div|


 
