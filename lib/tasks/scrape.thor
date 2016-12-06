class Scrape < Thor

	desc "ada_county","scrape ada county"
	def ada_county

    require File.expand_path('config/environment.rb')

    require 'rubygems'

    require 'nokogiri'

    require 'open-uri'

		require 'aws-sdk'

    require 'csv'

    require 'json'

		require 'mechanize'

		require 'watir'

		puts 'scraping ada county'

		chromedriver_path = File.join(File.absolute_path('C:/', File.dirname(__FILE__)),"chromedriver","chromedriver.exe")

		Selenium::WebDriver::Chrome.driver_path = chromedriver_path

	  browser = Watir::Browser.new :chrome

		browser.goto "https://adasheriff.org/webapps/sheriff/reports/"

		ada_county = County.find_by slug: 'ada'

		doc = Nokogiri::HTML browser.html

		arrests = doc.css('.arrest')

		list = doc.css('#Form1 strong')

		inmate_list = Array.new

		list.each do |item|

			inmate_list.push(item.text)

		end

		arrests.each do |arrest|

			name = arrest.css('.arrest-title-bar strong').text

				name = arrest.css('.arrest-title-bar strong').text.split(',')

				name = "#{name[1]} #{name[0]}"

				browser.div(:id => arrest.attr("id")).click

				sleep 2

			  doc = Nokogiri::HTML browser.html

				image = doc.css('#ContentPlaceHolder1_upMugShot img').attr('src').to_s

				name[0] = ''

			  info = arrest.css('.info').inner_html.split("<br>")

				puts name

			  age = info[0].gsub(/[^\d,]/,"")

				booking_date = info[1].gsub("Booking Date: ","")

			  charges = arrest.css('.newChargeWarrantLine:nth-child(3)')

				ada_county.mugshots.create!(:name => name, :age => age, :booking_time => booking_date)

				mugshot = Mugshot.last

				mugshot.photos.create!(:image => image)

			  if charges.length == 1

					mugshot.charges.create!(:charge => charges.text)

					puts charges.text

			  else

			    charges.each do |charge|

						mugshot.charges.create!(:charge => charge.text)

						puts charge.text

			    end

				end


		end

		ada_county.update(:list => inmate_list.to_json)

  end

	desc "canyon_county","scrape the mugshots on the following site"
	def canyon_county

    require File.expand_path('config/environment.rb')

    require 'rubygems'

    require 'nokogiri'

    require 'open-uri'

		require 'aws-sdk'

    require 'csv'

    require 'json'

		require 'mechanize'

		require 'watir'

		require 'watir-webdriver'

		# Specify the driver path
		chromedriver_path = File.join(File.absolute_path('../..', File.dirname(__FILE__)),"browsers","chromedriver.exe")
		Selenium::WebDriver::Chrome.driver_path = chromedriver_path

		puts 'scraping canyon county'

		chromedriver_path = File.join(File.absolute_path('C:/', File.dirname(__FILE__)),"chromedriver","chromedriver.exe")

		Selenium::WebDriver::Chrome.driver_path = chromedriver_path

	  browser = Watir::Browser.new :chrome

		browser.goto "http://apps.canyonco.org/wpprod/CurrentArrests.aspx?Page=Current_Arrests"

		canyon_county = County.find_by slug: 'canyon'

		doc = Nokogiri::HTML browser.html

		inmates = doc.css('tr:not(:first-child)')

		list = doc.css('.NameLink')

		inmate_list = Array.new

		list.each do |item|

			inmate_list.push(item.text)

		end

		inmates.each do |inmate|

			unless inmate.to_s.length < 500

				name = inmate.css('.NameLink').text

					arrest_date = inmate.css('td:nth-child(3) span').text

					charges = inmate.css('td:nth-child(4) span').inner_html

					photo = inmate.at_css('input').attr('src').gsub!('thumb', 'full')

					info = inmate.css('td:nth-child(3) span').inner_html

					puts name

					if charges.include? ('<br>')

						charges = charges.split('<br>')

					end

					canyon_county.mugshots.create!(:name => name, :booking_time => info)

					mugshot = Mugshot.last

					mugshot.photos.create!(:image => photo)

					if charges.is_a? Array

						charges.each do |charge|

							mugshot.charges.create!(:charge => charge)

							puts charge

				    end

					else

						mugshot.charges.create!(:charge => charges)

						puts charges

					end

				end


		end

		canyon_county.update(:list => inmate_list.to_json)

  end

end
