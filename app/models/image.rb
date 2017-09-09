class Image
  attr_accessor(:original_url) # String, original URL of image
  attr_accessor(:credit, :license) # Strings

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

  def author
    # use nameable here
  end

  def license
    # get the rest of the credit i guess?
  end
end
