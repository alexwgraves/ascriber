require 'nokogiri'
require 'open-uri'
require 'uri'

# creates a scraper object to scrape all images within the given website
class Scraper
  attr_accessor(:url, :search_entire_site)

  def initialize(url, recurse)
    @search_entire_site = recurse
    uri = URI(url)
    @url = uri.to_s
    @url = 'http://' + @url unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    @main_page = Nokogiri::HTML(open(@url))
    @urls = [URI(@url)]
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
  def scrape_images(figure)
    img = nil
    figure.search('img', 'figcaption').each do |result|
      if result.name == 'img' && !result.attr('src').nil?
        img_url = convert_url(result.attr('src'))
        img = Image.new(img_url)
      elsif result.name == 'figcaption'
        img.credit = result.text.strip unless img.nil?
      end
    end
    img.flagged = true if img.credit.empty?

    # printing for the time being to see output
    p img unless img.nil?
  end

  # recursively scrape all links and images within given website
  def scrape(page)
    page.search('a', 'figure').each do |link|
      scrape_images(link) if link.name == 'figure'
      scrape_links(link) if link.name == 'a'
    end
  end

  # scrape all images on just the given page
  def scrape_once(page)
    page.search('figure').each do |figure|
      scrape_images(figure)
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
