require 'sinatra'
require 'rubygems'

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production
)

require 'wiki.rb'
run Sinatra.application