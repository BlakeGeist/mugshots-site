module AdminHelper

  def re_fetch_mugshot(county)

    case county
    when 'ada'

      require File.expand_path('config/environment.rb')

      require 'rubygems'

      require 'nokogiri'

      require 'open-uri'

      require 'aws-sdk'

      require 'csv'

      require 'json'

      require 'mechanize'

      require 'watir'

      browser = Watir::Browser.new :phantomjs

      puts 're-fetching ' + @mugshot.name + 's mugshot'

  		args = %w{--ignore-ssl-errors=true}

  		browser = Watir::Browser.new(:phantomjs, :args => args)

  		browser.window.resize_to(1600, 1200)

  		browser.goto "https://adasheriff.org/webapps/sheriff/reports/"

  		ada_county = County.find_by slug: 'ada'

  		doc = Nokogiri::HTML browser.html

  		arrests = doc.css('.arrest')

      split_name = @mugshot.name.split(" ")

      arrests.each do |arrest|

        if arrest.text.include? (split_name[0])

          broser = browser.div(:id => arrest.attr("id")).fire_event :click

  				sleep 3

          doc = Nokogiri::HTML browser.html

          image = doc.css('#ContentPlaceHolder1_upMugShot img').attr('src').to_s

          @mugshot.photos.create!(:image => image)

        end

  		end

    when 'canyon'

      require File.expand_path('config/environment.rb')

      require 'rubygems'

      require 'nokogiri'

      require 'open-uri'

      require 'aws-sdk'

      require 'csv'

      require 'json'

      require 'mechanize'

      require 'watir'

      browser = Watir::Browser.new :phantomjs

  		puts 're-fetching ' + @mugshot.name + 's mugshot'

  		browser.goto "http://apps.canyonco.org/wpprod/CurrentArrests.aspx?Page=Current_Arrests"

  		canyon_county = County.find_by slug: 'canyon'

  		doc = Nokogiri::HTML browser.html

  		inmates = doc.css('tr:not(:first-child)')

  		inmates.each do |inmate|

  			unless inmate.to_s.length < 500

  				name = inmate.css('.NameLink').text

  				if name && name == @mugshot.name

  					photo = inmate.at_css('input').attr('src').gsub!('thumb', 'full')

  					@mugshot.photos.create!(:image => photo)

  				end

  			end

  		end

    when 'mecklenburg'

      require File.expand_path('config/environment.rb')

      require 'rubygems'

      require 'nokogiri'

      require 'open-uri'

      require 'aws-sdk'

      require 'csv'

      require 'json'

      require 'mechanize'

      require 'watir'

      browser = Watir::Browser.new :phantomjs

      puts 're-fetching ' + @mugshot.name + 's mugshot'

  		browser.goto @mugshot.org_url

  		mecklenburg_county = County.find_by slug: 'mecklenburg'

      sleep(3)

      doc = Nokogiri::HTML browser.html

			image = doc.css('#divDetailsDesktop [data-bind="attr:{src: ImageUrl}"]')

      puts image

			if image.to_s.length  > 10

				puts 'before set title'

				title = image.attr('src')

				puts 'after set title'

			end

			if title

				image = image.attr('src').to_s

				puts 'before image'

        @mugshot.photos.create!(:image => image)

        puts 'after image'

			end

    when 'horry'

      puts 're-fetching ' + @mugshot.name + 's mugshot'

      require File.expand_path('config/environment.rb')

      require 'rubygems'

      require 'nokogiri'

      require 'open-uri'

      require 'aws-sdk'

      require 'csv'

      require 'json'

      require 'mechanize'

      require 'watir'

      browser = Watir::Browser.new :phantomjs

      browser.goto "http://www.horrycounty.org/bookings"

  		horry_county = County.find_by slug: 'horry'

  		sleep 3

  		doc = Nokogiri::HTML browser.html

  		inmates = doc.css('#resultsTable .table tbody')

  		inmates.each do |inmate|

      	org_name = inmate.css('.cellLarge span:nth-child(1)').text

      	if org_name && org_name == @mugshot.org_name

      		image = inmate.css('img').attr('src').to_s

          @mugshot.photos.create!(:image => image)

      	end

  		end

    else

      puts 'fuck off, it didnt work'

    end

  end

end
