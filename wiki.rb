require 'rubygems'
require 'sinatra'
require 'redcloth'
require 'lib/wikipage'

configure do
  $wiki_path = File.dirname(__FILE__) + '/../wiki/'
end

template(:layout) do  
  :wiki
end

not_found do
  erb :'400'
end

error do
  @e = request.env['sinatra_error']
  erb :'500'
end

before do
  @root = Wiki::Page.new("").subpages
end

get '/' do
  @page = Wiki::Page.new("")
	erb :article
end

get '/*' do
  begin
    @page = Wiki::Page.new(params[:splat].first)
  rescue Exception => e
    raise Sinatra::NotFound
  end
  erb :article
end