require 'nokogiri'
require 'open-uri'
require 'uri'

@url = 'http://alex-graves.com'
@main_page = Nokogiri::HTML(open(@url))
@urls = [URI(@url)]
@img_urls = []

# convert all URLs to absolute URLs
def convert_url(rel_url)
  URI.join(@url, rel_url).to_s
end

# recurse on page if appropriate
def scrape_links(link)
  return if link.attr('href').nil?
  url = convert_url(link.attr('href'))
  return unless url.include?(@url)
  return if @urls.include?(URI(url))
  @urls << URI(url)
  scrape(Nokogiri::HTML(open(url)))
end

# add image URL to array
def scrape_images(img)
  return if img.attr('src').nil?
  img_url = convert_url(img.attr('src'))
  @img_urls << img_url
end

# recursively scrape all links and images within given website
def scrape(page)
  page.search('a', 'img').each do |link|
    scrape_images(link) if link.name == 'img'
    scrape_links(link) if link.name == 'a'
  end
end

scrape(@main_page)
@img_urls.each do |url|
  p url
end
