require 'nokogiri'
require 'open-uri'
require 'uri'

# creates a scraper object to scrape all images within the given website
class Scraper
  attr_accessor(:url, :search_entire_site)

  def initialize(url, recurse)
    @url = URI(url).to_s
    @search_entire_site = recurse
    @url = 'http://' + @url unless url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
    @main_page = Nokogiri::HTML(open(@url))
    @urls = [URI(@url)]
    @img_urls = []
  end

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

    # printing currently just to show output
    p img_url
  end

  # recursively scrape all links and images within given website
  def scrape(page)
    page.search('a', 'figure:img').each do |link|
      scrape_images(link) if link.name == 'img'
      scrape_links(link) if link.name == 'a'
    end
  end

  # scrape all images on just the given page
  def scrape_once(page)
    page.search('img').each do |link|
      scrape_images(link) if link.name == 'img'
    end
  end

  # actually runs the scraper
  def run
    if search_entire_site
      scrape(@main_page)
    else
      scrape_once(@main_page)
    end
  end
end
