require 'google/cloud/language'

class Image
  attr_accessor(:original_url) # String, original URL of image
  attr_accessor(:site_url) # for the host of the user's inputted URL
  attr_accessor(:credit, :flagged)

  def initialize(original_url)
    @original_url = original_url
    @credit = ''
    @flagged = false
  end

  # returns Hash of matching pages and their original pub date
  def matching_pages
    matching_img_urls = ImageParser.matching_pages(@original_url)
    pages = []
    matching_img_urls.each do |page|
      p "getting date for #{page.url}"
      dater = Dater.new(page.url)
      pages << { url: page.url, pubDate: dater.earliest }
    end
    same_source?(pages)
    pages
  end

  def same_source?(pages)
    earliest = pages.reject { |m| m[:pubDate].nil? }.sort_by { |m| m[:pubDate] }
    probable_og = earliest.first
    og_host = URI(probable_og[:url]).host
    @flagged = false if og_host == @site_url
  end

  def entities
    ImageParser.image_entities(@original_url)
  end

  def scrape_credit(credit)
    credit.split(/[\t\r\n\f]/).each do |text|
      text_down = text.downcase
      @credit += text.strip if text_down.include?('photo:') || text_down.include?('credit')
    end
    credit_manual(credit) if @credit.casecmp('credit').zero?
  end

  def credit_manual(credit)
    @credit = credit.partition('Credit').last.strip
  end

  def similar_images
    entity = entities[0].description
    p "searching for images of #{entity}"
    search_url = "https://www.googleapis.com/customsearch/v1?q=#{entity}&cx=015751805172374965118%3Abeunjl9htrk&fileType=png%2Cgif%2Cjpg%2Cjpeg&num=5&imgSize=large&rights=cc_publicdomain%2C+cc_attribute%2C+cc_sharealike&searchType=image&key=#{ENV['GOOGLE_CUSTOM_SEARCH_KEY']}"
    res = Net::HTTP.get_response(URI.parse(search_url))
    body = res.body
    json = JSON.parse(body)
    json
  end

  def authors
    project_id = 'ascriber-179402'
    language = Google::Cloud::Language.new project: project_id
    entities = language.document(@credit).entities
    authors = []
    entities.each do |entity|
      authors << entity.name if entity.type == :PERSON
    end
    authors
  end

  def source_links
    Attributer.credit_string(matching_pages)
  end
end
