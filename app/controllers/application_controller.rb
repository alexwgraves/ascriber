require 'sinatra'
Dir.glob('./scripts/*.rb').each { |file| require file }

ENV['GOOGLE_APPLICATION_CREDENTIALS'] = File.expand_path('../../throwaway-key.json', __FILE__)

class ApplicationController < Sinatra::Base
  use Rack::MethodOverride
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, 'public'

  get '/' do
    erb :'index.html'
  end

  get '/img-urls' do
    img = Image.new('http://snworksceo.imgix.net/dpn/7b303678-f097-4996-90da-1489b63a5be2.sized-1000x1000.png')
    img.matching_pages.to_s
  end

  get '/img-entities' do
    img = Image.new('http://snworksceo.imgix.net/dpn/5f93f181-9891-46b2-b3a8-b950b6bf43b9.sized-1000x1000.jpg')
    entities = img.entities
    entities.map { |entity| entity.description + '<br>' }
  end

  get '/url' do
    dater = Dater.new('www.thedp.com')
    dater.earliest
  end

  post '/' do
    scraper = Scraper.new(params[:url])
    scraper.run
    erb :'index.html'
  end
end
