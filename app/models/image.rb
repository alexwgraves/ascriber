class Image
  attr_accessor(:original_url) # String, original URL of image
  attr_accessor(:author, :license) # Strings

  def initialize(original_url)
    @original_url = original_url
  end

  # returns Hash of matching pages and their original pub date
  def matching_pages
    matching_img_urls = ImageParser.matching_pages(@original_url)
    pages = []
    matching_img_urls.each do |page|
      p "getting date for #{page.url}"
      dater = Dater.new(page.url)
      pages << { url: page.url, pubDate: dater.earliest.to_s }
    end
    pages
  end

  def entities
    ImageParser.image_entities(@original_url)
  end

  def similar_images
    entity = entities[0].description
    p "searching for images of #{entity}"
    search_url = "https://www.googleapis.com/customsearch/v1?q=#{entity}&cx=015751805172374965118%3Abeunjl9htrk&fileType=png%2Cgif%2Cjpg%2Cjpeg&num=5&rights=cc_publicdomain%2C+cc_attribute%2C+cc_sharealike&searchType=image&key=#{ENV['GOOGLE_CUSTOM_SEARCH_KEY']}"
    res = Net::HTTP.get_response(URI.parse(search_url))
    body = res.body
    json = JSON.parse(body)
    json
  end

end
