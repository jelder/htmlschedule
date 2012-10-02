require 'yaml'
require 'pp'
require 'erb'
require 'fileutils'

task :default => [:generate]

task :generate do
  schedule = begin
    YAML::load(File.open("config.yml"))["schedule"]
  rescue Exception => e
    puts %q{

      Your config.yaml should look like this:

      schedule:
        - name: mything
          url: http://mything.com
        - name: thing2
          url: https://www.otherthing.net/
          duration: 20

    }.gsub(/^\s{4}/,'')
    exit
  end

  SUFFIX = ".html"
  DOCROOT = "docroot"
  TEMPLATE = "template.html.erb"

  FileUtils.mkdir DOCROOT unless File.exists? DOCROOT

  # Generate a series of HTML files with circular meta-refresh links. 
  schedule.each_with_index do |slot,i|
    slot["duration"] ||= 60
    @slot = slot
    @next_slot = if i+1 == schedule.length
      schedule.first
    else
      schedule[i+1]
    end
    template = ERB.new(IO.read(TEMPLATE), 0, '%<>')
    target = File.new(File.join(DOCROOT,slot["name"] + SUFFIX), "w") 
    target.write(template.result)
  end

  # And create a starting point
  @slot, @next_slot = schedule[0,2]
  template = ERB.new(IO.read(TEMPLATE), 0, '%<>')
  target = File.new(File.join(DOCROOT,"index" + SUFFIX), "w") 
  target.write(template.result)
end
