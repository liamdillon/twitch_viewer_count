#!/home/ubuntu/.rbenv/shims/ruby

require 'fileutils'

FileUtils.rm('parsed_counts.txt') if File.exist?('parsed_counts.txt')

f = open('viewer_counts.txt', 'r')

open('parsed_counts.txt', 'a') do |p|
  p.puts 'Timestamp,Total Channels,Total Viewers,Top 25'
  f.each_line do |line|
    if line.include? 'Timestamp'
      p << line.split(' ')[1].gsub("\n","") + ','
      print line.split(' ')[1] + ','
    end
    if line.include? 'Number of channels'
      p << line.split(': ')[1].gsub("\n","") + ','
      print line.split(': ')[1] + ','
    end
    if line.include? 'Total viewers:'
      p << line.split(': ')[1].gsub("\n","") + ','
      print line.split(': ')[1]      
    end
    if line.include? '['
      p << line
      print line
    end
  end
end

f.close
