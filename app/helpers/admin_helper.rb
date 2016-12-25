module AdminHelper

  def re_fetch_mugshot(county)

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


  end

end
