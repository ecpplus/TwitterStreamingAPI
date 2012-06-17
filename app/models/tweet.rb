# -*- encoding: utf-8 -*-

require 'logger'
require 'net/http'
require 'json'

class Tweet
  include Mongoid::Document
  field :user_id,         type: Integer
  field :twitter_post_id, type: String
  field :text,            type: String
  field :posted_at,       type: Time

  class << self
    def fetch_streaming
      uri = URI.parse(TwitterSettings.twitter_streaming_url)
      connection = Net::HTTP.new(uri.host, uri.port) 
      connection.use_ssl = true
      connection.start do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth(TwitterSettings.twitter_username, TwitterSettings.twitter_password)

        http.request(request) do |response|
          response.read_body do |body|
            body.each_line("\r") do |line|
              status = JSON.parse(line) rescue next
              next unless status['text']
              p status['text'] if status['text'] =~ /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/
              #create_from_json(status)
            end
          end
        end
      end
    end

    def create_from_json(status)
      p create(
        :user_id             => status['user']['id'],
        :twitter_post_id     => status['id'],
        :text                => status['text'],
        :in_reply_to_user_id => status['in_reply_to_user_id']
      )
    end

  end
end
