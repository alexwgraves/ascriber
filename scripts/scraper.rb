require 'nokogiri'
require 'open-uri'
require 'uri'

@url = 'http://thedp.com'

# convert all URLs to absolute URLs
def convert_url(rel_url)
  URI.join(@url, rel_url).to_s
end

urls = []

# get one layer deep of URLs
doc = Nokogiri::HTML(open(@url))
doc.search('a').each do |link|
  next if link.attr('href').nil? || link.attr('href').empty?
  scraped_url = convert_url(link.attr('href'))
  urls << scraped_url if scraped_url.include?(@url)
end

img_urls = []

# search each URL for images
urls.each do |page_url|
  page = Nokogiri::HTML(open(page_url))
  page.search('img').each do |img|
    next if img.attr('src').nil?
    img_url = convert_url(img.attr('src'))
    img_urls << img_url
  end
end
