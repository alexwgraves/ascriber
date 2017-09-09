class Image
  attr_accessor(:original_url) # String, original URL of image
  attr_accessor(:author, :license) # Strings

  def initialize(original_url)
    @original_url = original_url
  end

  # returns Hash of matching pages and their original pub date
  def matching_pages
    matching_img_urls = ImageParser::matchingPages(@original_url)
  end

  def entities
    ImageParser::imageEntities('http://snworksceo.imgix.net/dpn/5f93f181-9891-46b2-b3a8-b950b6bf43b9.sized-1000x1000.jpg')
  end
end
