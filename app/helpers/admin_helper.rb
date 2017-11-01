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

  		require 'selenium-webdriver'

  		puts 're-fetching mugshot'

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

  		puts 're-fetching ' + @mugshot.name + 's mugshot'

  		browser = Watir::Browser.new :phantomjs

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

  		puts 'scraping mecklenburg county'

  		browser = Watir::Browser.new :phantomjs

  		browser.goto @mugshot.org_url

  		mecklenburg_county = County.find_by slug: 'mecklenburg'

			doc = Nokogiri::HTML browser.html

			image = doc.css('#divDetailsDesktop [data-bind="attr:{src: ImageUrl}"]')

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

    else

      puts 'fuck off, it didnt work'

    end

  end

end
