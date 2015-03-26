#!/home/ubuntu/.rbenv/shims/ruby

gem 'httparty'

require 'httparty'
require 'active_support/core_ext/enumerable'
require 'active_support/time'
require 'fileutils'

url = 'https://api.twitch.tv/kraken/streams?game=Heroes%20of%20the%20Storm'

headers = {'ContentType' => 'application/vnd.twitchtv[.version]+json'}

resp = HTTParty.get(url, options: {headers: headers})

summary = HTTParty.get('https://api.twitch.tv/kraken/streams/summary', query: {"game" => "Heroes of the Storm"}, options: {headers: headers}).parsed_response

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

puts "summary: "
puts summary.to_yaml
puts "counts: " + counts.to_s

current_time = DateTime.now.change(offset: '-0700') - 7.hours

open('viewer_counts.txt', 'a') do |f|
  f.puts '-'*25
  f.puts "Timestamp: " + current_time.to_s
  f.puts ""
  f.puts "Number of channels: " + summary["channels"].to_s
  f.puts ""
  f.puts "Total viewers: " + summary["viewers"].to_s
  f.puts ""
  f.puts "Total viewers for top 25 streams:"
  f.puts counts.sum.to_s
  f.puts ""
  f.puts "Viewer counts:"
  f.puts counts.to_s
  f.puts '-'*25
  f.puts ""
end

FileUtils.cd('details') do
  open("details_#{current_time}.txt", 'a') do |f|
    f.puts '-'*25
    f.puts "Timestamp: " + current_time.to_s
    f.puts ""
    f.puts "Number of channels: " + summary["channels"].to_s
    f.puts ""
    f.puts "Total viewers: " + summary["viewers"].to_s
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
