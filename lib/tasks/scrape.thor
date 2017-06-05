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

		require 'selenium-webdriver'

		puts 'scraping ada county'

		args = %w{--ignore-ssl-errors=true}

		browser = Watir::Browser.new(:phantomjs, :args => args)

		browser.window.resize_to(1600, 1200)

		browser.goto "https://adasheriff.org/webapps/sheriff/reports/"

		ada_county = County.find_by slug: 'ada'

		doc = Nokogiri::HTML browser.html

		arrests = doc.css('.arrest')

		list = doc.css('#Form1 strong')

		inmate_list = Array.new

		new_que_list = Array.new

		list.each do |item|

			inmate_list.push(item.text)

		end

		if ada_county.list.nil?

			ada_county.list = Array.new

		end

		if ada_county.que_list.nil?

			ada_county.que_list = Array.new

		end

		list_from_last_time = JSON.parse ada_county.list

		inmate_list.each do |item|

			unless list_from_last_time.include? item

				new_que_list.push(item)

			end

		end

		arrests.each do |arrest|

			name = arrest.css('.arrest-title-bar strong').text

			unless ada_county.list.include? name

				name = arrest.css('.arrest-title-bar strong').text.split(',')

				name = "#{name[1]} #{name[0]}"

				broser = browser.div(:id => arrest.attr("id")).fire_event :click

				sleep 3

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

		end

		ada_county.update(:list => inmate_list.to_json)

		ada_county.update(:que_list => new_que_list.to_json)

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

		puts 'scraping canyon county'

		browser = Watir::Browser.new :phantomjs

		browser.goto "http://apps.canyonco.org/wpprod/CurrentArrests.aspx?Page=Current_Arrests"

		canyon_county = County.find_by slug: 'canyon'

		doc = Nokogiri::HTML browser.html

		inmates = doc.css('tr:not(:first-child)')

		list = doc.css('.NameLink')

		inmate_list = Array.new

		new_que_list = Array.new

		list.each do |item|

			inmate_list.push(item.text)

		end

		if canyon_county.list.nil?

			canyon_county.list = Array.new

		end

		if canyon_county.que_list.nil?

			canyon_county.que_list = Array.new

		end

		list_from_last_time = JSON.parse canyon_county.list

		inmate_list.each do |item|

			unless list_from_last_time.include? item

				new_que_list.push(item)

			end

		end

		inmates.each do |inmate|
			unless inmate.to_s.length < 500

				name = inmate.css('.NameLink').text

				if canyon_county.que_list.include? name

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

		end

		canyon_county.update(:list => inmate_list.to_json)

		canyon_county.update(:que_list => new_que_list.to_json)

  end

	desc "charleston_county","scrape the mugshots on the following site"
	def charleston_county

		require File.expand_path('config/environment.rb')

		require 'rubygems'

		require 'nokogiri'

		require 'open-uri'

		require 'aws-sdk'

		require 'csv'

		require 'json'

		require 'mechanize'

		require 'watir'

		puts 'scraping charleston county'

		browser = Watir::Browser.new :phantomjs

		browser.goto "http://inmatesearch.charlestoncounty.org/"

		horry_county = County.find_by slug: 'charleston'

		doc = Nokogiri::HTML browser.html

		puts doc

	end

	desc "horry_county","scrape the mugshots on the following site"
	def horry_county

		require File.expand_path('config/environment.rb')

    require 'rubygems'

    require 'nokogiri'

    require 'open-uri'

		require 'aws-sdk'

    require 'csv'

    require 'json'

		require 'mechanize'

		require 'watir'

		puts 'scraping horry county'

		browser = Watir::Browser.new :phantomjs

		browser.goto "http://www.horrycounty.org/bookings"

		horry_county = County.find_by slug: 'horry'

		sleep 3

		doc = Nokogiri::HTML browser.html

		inmates = doc.css('#resultsTable .table tbody')

		list = doc.css('#resultsTable .cellLarge span:nth-child(1)')

		inmate_list = Array.new

		new_que_list = Array.new

		list.each do |item|

			inmate_list.push(item.text)

		end

		#puts inmate_list

		if horry_county.list.nil?

			horry_county.list = Array.new

		end

		puts "inmate count list #{inmates.count}"

		inmates.each do |inmate|
			name = inmate.css('.cellLarge span:nth-child(1)').text
			unless horry_county.list.include? name
				arrest_date = inmate.css('.cellSmall:nth-child(5)').text
				charges = inmate.css('.clear-cell-border ul li')
				image = inmate.css('img').attr('src').to_s
				#puts "name: #{name}"
				#puts 'before image'
				#puts image
				#puts 'after image'
				#puts "charge count: #{charges.count}"
				if charges.length > 0 && charges.text != "No Charges Listed" && charges.text != '' && image != 'http://www.horrycounty.org/mugshot/mugshot/null'
					horry_county.mugshots.create!(:name => name, :booking_time => arrest_date)
					mugshot = Mugshot.last
					charges.each do |charge|
						mugshot.charges.create!(:charge => charge.text)
						#puts charge.text
			    end
					#puts 'before photo create'
					mugshot.photos.create!(:image => image)
				else
					inmate_list.delete(name)
					#puts 'mugshot deleted'
				end
				#puts 'after image check'
			end
		end
		#puts 'before inmate list'
		if inmates.count > 0
			horry_county.update(:list => inmate_list.to_json)
		end
		#puts 'after inamte list'
	end
end
