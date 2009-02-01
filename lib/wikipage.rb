module Wiki
  class Page
    
    attr_reader :url,:is_folder
    
    def initialize path
      if path.empty?
        @fullpath = $wiki_path
        @url = "."
      else
        @fullpath = $wiki_path + path
        @url = path
      end
      @is_folder = File.exists? @fullpath
      @has_content = File.exists? doc
    end
    
    def doc
      @fullpath + ".textile"
    end
    
    def time
      if @has_content
        File.open(doc).mtime
      else
        File.open(@fullpath).mtime
      end
    end
    
    def ftime
      time.strftime "%Y-%m-%d"
    end
    
    def subpages
      if @is_folder
        Dir.new(@fullpath).entries.delete_if do |i| 
          i[0] == 46 
        end.map do |f| 
          f.sub(".textile","")  
        end.uniq.map do |p| 
          Page.new(@url + "/" + p)
        end
      else
        Array.new
      end
    end
    
    def sorted_subpages
      subpages.sort_by { |i| i.time }.reverse
    end
    
    def content
      if @has_content
        RedCloth.new(File.new(doc).read).to_html        
      elsif @is_folder
        "<h1>#{to_s}</h1>"
      else
        raise Sinatra::NotFound
      end
    end
    
    def to_s
      if @url == "."
        "Root"
      else
        @url.split("/").last
      end
    end
    
    def latest(n)

       def rec(r)
          l = Array.new 
          unless r.is_folder
            l << r
          end
          r.subpages.each do |sp|
            l += rec(sp)
          end
          l 
       end

       rec(self).sort_by{ |i| i.time }.reverse.first(n)
     end
    
  end
end