require 'rubygems' 
require 'sinatra' 

get '/' do 
  # redirect '/index.html' 
  File.new('public/index.html').readlines
end