require 'rubygems'
require 'kramdown'
require 'cgi'

module Shimokita
  def self.generateFileName(num)
    'file' + num.to_string + '.txt'
  end
  
  def self.extractFileName(line)
    line.split(" ").last
  end
end

filename = '/Users/kabayaki91/github/CakePHP2.0practicalguide/chapter01/readme.md'
outputpath = './out/'
mdown_src = File.read(filename);
start = false;
buff = '';
num = 0;
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
    if outfilename.length == 0 then
      outfilename = Shimokita.generateFileName(num)
    end
    start = true
    num += 1
    puts "Opening file for writing:" + outputpath + outfilename
    fp = File.open(outputpath + outfilename,"w")
  end

end
