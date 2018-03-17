# _*_ coding: utf-8 _*_
require 'anemone'
require 'nokogiri'
require 'kconv'

urls = []
urls.push("http://www.dmm.com/keyword/-/day/")

opts = {
  :depth_limit => 0,
  :delay => 1
}

Anemone.crawl(urls, opts) do |anemone|
  anemone.on_every_page do |page|
    doc = Nokogiri::HTML.parse(page.body.toutf8)

    category = doc.xpath("//*[@id='zg_browseRoot']/ul/li/a").text
    sub_category = doc.xpath("//*[@id=\"zg_listTitle\"]/span").text
    puts category + "/" + sub_category

    items = doc.xpath("//span[@class=\"keyword_middle\"]/a[1]")

    items.each do |item|
      # 順位
      #rank = item.xpath("div[1]/span[@class=\"zg_rankNumber\"]").text
      # 書名
      #title = item.xpath("div[\"zg_title\"]/a").text.gsub(' ', '')
      # SERIAL
      href = item.attribute("href")
		puts item.text()
      puts "#{href} "
      #puts item
    end
  end
end
