#!/home/liam/.rvm/rubies/ruby-1.9.3-p448/bin/ruby

gem 'httparty'

require 'httparty'
require 'active_support/core_ext/enumerable'
require 'fileutils'

url = 'https://api.twitch.tv/kraken/streams?game=Heroes%20of%20the%20Storm'

headers = {'ContentType' => 'application/vnd.twitchtv[.version]+json'}

resp = HTTParty.get(url, options: {headers: headers})

streams = resp.parsed_response["streams"]

info = {}
counts = []

streams.each do |s|
  channel = s["channel"]
  channel_name = channel["name"]
  info[channel_name] = {}
  info[channel_name]["viewers"] = s["viewers"]
  info[channel_name]["status"] = channel["status"]
  counts << s["viewers"].to_i
end

puts "counts: " + counts.to_s

open('counts.txt', 'a') do |f|
  f.puts '-'*25
  f.puts "Timestamp: " + DateTime.now.to_s
  f.puts ""
  f.puts "Total Viewers for top 25 streams:"
  f.puts counts.sum.to_s
  f.puts ""
  f.puts "Viewer counts:"
  f.puts counts.to_s
  f.puts '-'*25
  f.puts ""
end

current_time = DateTime.now.to_s

FileUtils.cd('details') do
  open("details_#{current_time}.txt", 'a') do |f|
    f.puts '-'*25
    f.puts "Timestamp: " + current_time
    f.puts ""
    f.puts "Total Viewers for top 25 streams:"
    f.puts counts.sum.to_s
    f.puts ""
    f.puts "Viewer counts:"
    f.puts counts.to_s
    f.puts ""
    f.puts info.to_yaml
    f.puts '-'*25
    f.puts ""
  end
end
