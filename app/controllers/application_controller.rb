require 'sinatra'
Dir.glob('./scripts/*.rb').each { |file| require file }

ENV['GOOGLE_APPLICATION_CREDENTIALS'] = File.expand_path('../../throwaway-key.json', __FILE__)
ENV['GOOGLE_CUSTOM_SEARCH_KEY'] = 'AIzaSyBhjYOx43kHpWJhUWKCE-5JV2O91K0hQ5I'

class ApplicationController < Sinatra::Base
  use Rack::MethodOverride
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, 'public'

  get '/' do
    erb :'index.html'
  end

  post '/similar' do
    p params['search_url']
    img = Image.new(params['search_url'])
    img.similar_images
  end

  get '/url' do
    dater = Dater.new('www.thedp.com')
    dater.earliest
  end

  post '/' do
    recurse = true
    recurse = false if params[:recurse].nil?
    uri = URI(params[:url])
    @url = uri.to_s
    @url = 'http://' + @url unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    scraper = Scraper.new(@url, recurse)
    @scraped = scraper.run
    erb :'results.html'
  end
end
