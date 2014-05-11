#!/usr/bin/env ruby

require 'rss'
require 'net/http'
require 'base64'
require 'mandrill'

mandrill = Mandrill::API.new
feed = RSS::Parser.parse(ENV['FEED_URL'])

feed.entries.each do |entry|
  if entry.updated.content > Time.now - 24*60*60
    puts "processing #{entry.id.content} at #{entry.link.href}"
    html = entry.content.content

    html.scan(/<img[^>]+src="([^">]+\.jpe?g)"/i) do |(url)|
      puts "downloading #{url}"
      uri = URI(url)
      filename = File.basename(uri.path)
      img = Net::HTTP.get(uri)
      enc = Base64.encode64(img)

      message = {"html"=>"<a href='#{url}'><img src='#{url}'></a>",
           "track_opens" => false,
           "track_clicks" => false,
           "subject"=>entry.title.content + ' ' + filename,
           "from_email"=>ENV['MY_EMAIL'],
           "to"=>
              [{"email"=>ENV['TO_EMAIL'],
                  "type"=>"to"}],
           "attachments"=>
              [{"type"=>"image/jpeg", "name"=>filename, "content"=>enc}]}

      result = mandrill.messages.send message
      puts "message send result: #{result}"
    end
  end
end
