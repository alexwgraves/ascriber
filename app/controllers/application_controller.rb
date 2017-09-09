require 'sinatra'
require 'googleauth'
require './scripts/dater.rb'


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
    image_path = 'http://snworksceo.imgix.net/dpn/5f93f181-9891-46b2-b3a8-b950b6bf43b9.sized-1000x1000.jpg'

    scopes = ['https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/cloud-vision']
    authorization = Google::Auth.get_application_default(scopes)

    require 'google/cloud/vision'

    vision = Google::Cloud::Vision.new project: project_id
    # vision.authorization = authorization
    image = vision.image image_path

    web = image.web

    returnstr = '<b>URLS:</b><br>'

    web.pages_with_matching_images.each do |page|
      p page
      returnstr += page.url + '<br>'
    end
    returnstr += "<br><br> <b>ENTITIES:</b><br>"

    p web.entities

    web.entities.each do |entity|
      returnstr += entity.description + '<br>'
    end

    returnstr
  end

  get '/url' do
    dater = Dater.new('www.thedp.com')
    dater.run
  end


end
