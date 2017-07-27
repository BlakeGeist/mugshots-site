xml.instruct! :xml, :version => "1.0"
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @states.each do |state|
    state.counties.each do |county|
      xml.url do
        xml.loc state_county_url(state, county)
        xml.lastmod county.updated_at.to_date
        xml.changefreq "never"
        xml.priority "0.7"
      end
      county.mugshots.each do |mugshot|
        xml.url do
          xml.loc state_county_mugshot_url(state, county, mugshot)
          xml.lastmod mugshot.updated_at.to_date
          xml.changefreq "never"
          xml.priority "0.7"
        end
      end
    end
  end
end
