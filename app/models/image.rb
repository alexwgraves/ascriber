class Image
  attr_accessor(:original_url) # String, original URL of image
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
      pages << { url: page.url, pubDate: dater.earliest.to_s }
    end
    pages
  end

  def entities
    ImageParser.image_entities(@original_url)
  end

  def scrape_credit(credit)
    @credit = credit.partition('Credit').last.tr(':', '').strip
    @credit = credit.partition('Photo').last.tr(':', '').strip if @credit.empty?
  end
end
