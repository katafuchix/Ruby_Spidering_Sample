# _*_ coding: utf-8 _*_
require 'anemone'
require 'nokogiri'
require 'kconv'

urls = []
urls.push("http://www.dmm.com/digital/idol/")

opts = {
  :depth_limit => 0,
  :delay => 1
}

def getInfo(url)
puts url
	title = ""
	package = ""
	description = ""
	release_date = "";
	actress = ""
	series = ""
	maker = ""
	label = ""
	genre = ""
	limit = ""
	
	opts = {:depth_limit => 0, :delay => 1, :accept_cookies => true, :cookies => { "V_LIMIT" => 1}}
	Anemone.crawl(url, opts) do |anemone|
		anemone.on_every_page do |page|
			doc = Nokogiri::HTML.parse(page.body.toutf8)
			#puts page.body.toutf8
			begin
				title = doc.xpath("//h1[@id=\"title\"][1]").text.strip
			rescue
			end
			
			begin
				package = doc.xpath("//*[@name=\"package-image\"][1]").attribute("href")
				#puts package
			rescue
			end
			
			begin
				description = doc.xpath("//div[@class=\"mg-b20 lh4\"]").text.strip
			rescue
			end
			
			begin
				release_date = doc.xpath("//table[@class=\"mg-b20\"]/tr[2]/td[2]").text
				puts release_date
			rescue
			end
			
			begin
				limit = doc.xpath("//p[@class=\"mv-sale\"]/span[1]").text
				re = Regexp.new('(\d+)月(\d+)日')
				m = re.match(limit)
				p m
				puts m[1]
				puts m[2]
				re = Regexp.new('(\d+):(\d+)')
				n = re.match(limit)
				p n
				d = Date.today
				limit = d.strftime("%Y") + "-" + m[1] + "-" + m[2] + " " + n[1] + ":" + n[2] + ":00"
				puts limit
			rescue
			end
			
			item = doc.xpath("//table[@class=\"mg-b20\"]")
			trs =  item.xpath("tr")
				trs.each do |tr|
					text = tr.text.gsub(/(\r\n|\r|\n|\f)/,"")
					r = text.match(/発売日：(.+)/)
					begin
						release_date = r[1].strip
					rescue
					end
					a = text.match(/出演者：(.+)/)
					begin
						actress = a[1].strip
					rescue
					end
					s = text.match(/シリーズ：(.+)/)
					begin
						series = s[1].strip
					rescue
					end
					m = text.match(/メーカー：(.+)/)
					#puts text
					begin
						maker = m[1].strip
					rescue
					end
					l = text.match(/レーベル：(.+)/)
					begin
						label = l[1].strip
					rescue
					end
					g = text.match(/ジャンル：(.+)/)
					begin
						genre = g[1].strip
					rescue
					end
					#puts "\n"
				end
			
			
		end
	end
	return title, package, description, release_date, actress, series, maker, label, genre, limit
end

url = "http://www.dmm.co.jp/digital/videoa/-/detail/=/cid=h_937mna00002/"
title, package, description, release_date, actress, series, maker, label, genre, limit = getInfo(url)
			puts title
			puts package
			puts description
			puts release_date
			puts "actress : " + actress
			puts "series : " + series
			puts maker
			puts label
			puts genre
			puts limit

