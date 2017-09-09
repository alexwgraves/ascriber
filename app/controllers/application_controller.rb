require 'sinatra'
require 'googleauth'

ENV['GOOGLE_APPLICATION_CREDENTIALS'] = File.expand_path('../../throwaway-key.json', __FILE__)

class ApplicationController < Sinatra::Base
  use Rack::MethodOverride
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, 'public'

  get '/' do
    erb :'index.html'
  end

  get '/api' do
    project_id = 'ascriber-179402'
    image_path = 'https://i.imgur.com/X3VJ8Ax.jpg'

    scopes = ['https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/cloud-vision']
    authorization = Google::Auth.get_application_default(scopes)

    require 'google/cloud/vision'

    vision = Google::Cloud::Vision.new project: project_id
    image = vision.image image_path

    web = image.web

    web.entities.each do |entity|
      entity.description
    end

    web.full_matching_images.each do |image|
      puts image
    end

    erb :'index.html'
  end

end
