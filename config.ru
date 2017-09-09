require 'sinatra'
require 'bundler'

set :environment, :development
set :public_folder, proc { File.join(root, 'public') }
set :views, proc { File.join(root, 'views') }

Dir.glob('./app/{controllers,models}/*.rb').each { |file| require file }

run ApplicationController
