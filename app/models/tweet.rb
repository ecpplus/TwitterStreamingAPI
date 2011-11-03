require 'logger'
require 'net/http'
require 'json'

class Tweet < ActiveRecord::Base

  class << self
    def fetch_streaming
      uri = URI.parse(STREAMING_URL)
      connection = Net::HTTP.new(uri.host, uri.port) 
      connection.use_ssl = true
      connection.start do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth(TWITTER_USERNAME, TWITTER_PASSWORD)

        http.request(request) do |response|
          response.read_body do |body|
            body.each_line("\r") do |line|
              status = JSON.parse(line) rescue next
              next unless status['text']
              create_from_json(status)
            end
          end
        end
      end
    end

    def create_from_json(status)
      create(
        :user_id             => status['user']['id'],
        :twitter_post_id     => status['id'],
        :text                => status['text'],
        :in_reply_to_user_id => status['in_reply_to_user_id']
      )
    end

  end
end
