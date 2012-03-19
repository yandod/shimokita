require 'rubygems'
require 'kramdown'
require 'cgi'

module Shimokita
  def self.generateFileName(num)
    'file' + sprintf("%04d",num) + '.txt'
  end
  
  def self.extractFileName(line)
    list = line.split(" ")
    if (list.count == 1) then
      return false
    end
    list.last
  end
end

if ARGV.size != 2 then
  puts "shimokita.rb [markdown file] [output path]"
  exit
end

filename = ARGV[0]
outputpath = ARGV[1]
mdown_src = File.read(filename)
extract_name = false
start = false
num = 1 
fp = nil

Kramdown::Document.new(mdown_src).to_html.split("\n").each do |line|

  # find close tag for code.
  if start && line.include?("</code></pre>") then
    start = false
    fp.close
  end

  if start then
    fp.puts CGI.unescapeHTML(line)
  end

  # find open tag for code.
  if !start && line.include?("<pre><code>") then
    outfilename = Shimokita.extractFileName(line)
    if outfilename == false or extract_name == false then
      outfilename = Shimokita.generateFileName(num)
    end
    start = true
    num += 1
    puts "Opening file for writing:" + outputpath + outfilename
    fp = File.open(outputpath + outfilename,"w")
  end

end
