ENV['GEM_PATH'] = '/home/alcidesrails/.gems:/usr/lib/ruby/gems/1.8'
require 'sinatra'
require 'rubygems'
 
disable :run
set :env,  :production
set :views, File.dirname(__FILE__) + '/views'
set :public, File.dirname(__FILE__) + '/public'
set :app_file, __FILE__
 
require 'wiki.rb'
run Sinatra.application
