#!/home/ubuntu/.rbenv/shims/ruby

f = open('viewer_counts.txt', 'r')

open('parsed_counts.txt', 'a') do |p|
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
