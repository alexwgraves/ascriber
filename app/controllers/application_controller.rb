require 'sinatra'
require 'uri'
require './scripts/scraper.rb'

class ApplicationController < Sinatra::Base
  use Rack::MethodOverride
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, 'public'

  get '/' do
    erb :'index.html'
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
