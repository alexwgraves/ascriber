require 'sinatra'
require 'uri'

ENV['GOOGLE_APPLICATION_CREDENTIALS'] = File.expand_path('../../throwaway-key.json', __FILE__)

# Require all scripts
Dir.glob('./scripts/*.rb').each { |file| require file }

class ApplicationController < Sinatra::Base
  use Rack::MethodOverride
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, 'public'

  get '/' do
    erb :'index.html'
  end

  get '/img-urls' do
    img = Image.new('http://snworksceo.imgix.net/dpn/5f93f181-9891-46b2-b3a8-b950b6bf43b9.sized-1000x1000.jpg')
    pages = img.matching_pages
    pages.map{ |page| page.url + '<br>' }
  end

  get '/img-entities' do
    img = Image.new('http://snworksceo.imgix.net/dpn/5f93f181-9891-46b2-b3a8-b950b6bf43b9.sized-1000x1000.jpg')
    entities = img.entities
    entities.map{ |entity| entity.description + '<br>' }
  end

  get '/url' do
    dater = Dater.new('www.thedp.com')
    dater.run
  end

  post '/' do
    uri = URI(params[:url])
    url = uri.to_s
    url = 'http://' + url unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    scraper = Scraper.new(url)
    scraper.run
    erb :'index.html'
  end

end
