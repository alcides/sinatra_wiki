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
  @pages = Wiki::Page.new("").latest(10)
	erb :latest
end


get '/rss.xml' do
  home = Wiki::Page.new("").latest(5)

  builder(:layout=> false) do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title  "Alcides Fonseca wiki"
        xml.description "Writing playground of a lunatic"
        xml.link "http://wiki.alcidesfonseca.com"

        home.each do |page|
          xml.item do
            xml.title page.to_s
            xml.link "http://wiki.alcidesfonseca.com/#{page.url}"
            xml.description page.content
            xml.pubDate page.time
            xml.guid "http://wiki.alcidesfonseca.com/#{page.url}"
          end
        end
      end
    end
  end
end

get '/*' do
  begin
    @page = Wiki::Page.new(params[:splat].first)
  rescue Exception => e
    raise Sinatra::NotFound
  end
  erb :article
end