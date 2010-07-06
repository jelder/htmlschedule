#!/usr/bin/env ruby
require 'yaml'
require 'pp'
require 'erb'

config = YAML::load(File.open("config.yml"))

SUFFIX = ".html"

# Build a simple {duration,url,name} array from the more expressive configuration file.
schedule = []
config["schedule"].each do |slot|
    schedule << {
        :name => slot["name"],
        :url => config["url"] + "?" + slot["params"].map {|k,v| "#{k}=#{v}"}.sort.join("&"),
        :duration => slot["duration"]
    }
end

# Generate a series of HTML files with meta-refresh tags pointing to one another.
schedule.size.times do |slot|
    next_slot = slot + 1
    next_slot = 0 if next_slot == schedule.size
    @name = schedule[slot][:name]
    @duration = schedule[slot][:duration]
    @url = schedule[slot][:url] 
    @next = schedule[next_slot][:name] + SUFFIX 
    template = ERB.new(IO.read(config["template"]), 0, '%<>')
    target = File.new(File.join("html",@name + SUFFIX), "w") 
    target.write(template.result)
end
