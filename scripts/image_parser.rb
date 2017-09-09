require 'googleauth'
require 'google/cloud/vision'

class ImageParser
  def self.matching_pages(url)
    image = get_image_props(url)
    web = image.web

    web.pages_with_matching_images
  end

  def self.image_entities(url)
    image = get_image_props(url)
    web = image.web
    web.entities
  end

  def self.get_image_props(url)
    project_id = 'ascriber-179402'
    scopes = ['https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/cloud-vision']
    Google::Auth.get_application_default(scopes)

    vision = Google::Cloud::Vision.new project: project_id
    vision.image url
  end
end
