require 'googleauth'
require 'google/cloud/vision'

class ImageParser
  def self.matchingPages(url)
    image = getImageProps(url)
    web = image.web

    web.pages_with_matching_images
  end

  def self.imageEntities(url)
    image = getImageProps(url)
    web = image.web
    web.entities
  end

  private

  def self.getImageProps(url)
    project_id = 'ascriber-179402'
    scopes = ['https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/cloud-vision']
    authorization = Google::Auth.get_application_default(scopes)

    vision = Google::Cloud::Vision.new project: project_id
    vision.image url
  end

end
