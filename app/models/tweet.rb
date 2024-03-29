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
              next if status['text'].blank?
              if status['text'] =~ /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/
                pn = {p:0, n:0}
                Word.positive_words.each do |word|
                  if status['text'] =~ word # /#{word}/
                    pn[:p] += 1
                    #p "p:#{word}"
                  end
                end
                Word.negative_words.each do |word|
                  if status['text'] =~ word #/#{word}/
                    pn[:n] += 1 
                    #p "n:#{word}"
                  end
                end
                if 0 < pn[:n] + pn[:p]
                  #p status['text']
                  #p pn
                  TweetScore.create!(
                    positive: pn[:p], 
                    negative: pn[:n],
                    created_at: Time.parse(status['created_at'])
                  )
                end
                #create_from_json(status)
              end
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
