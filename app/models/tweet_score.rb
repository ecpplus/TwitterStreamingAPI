class TweetScore
  include Mongoid::Document
  field :positive, type: Integer, default: 0
  field :negative, type: Integer, default: 0
  field :created_at, null: false
  index :created_at

  class << self
    def post_to_growth_forecast
      now = Time.now
      pn = {positive: 0, negative: 0}
      TweetScore.where(:created_at.gt => now.ago(1.hour).to_time, :created_at.lt => Time.now).each do |tweet_score|
        pn[:positive] += tweet_score.positive
        pn[:negative] += tweet_score.negative
      end
      
      # TODO move to config
      `curl -F number=#{pn[:positive]} -F mode=gauge http://localhost:5125/api/Twitter/PNScore/positive`
      `curl -F number=#{pn[:negative]} -F mode=gauge http://localhost:5125/api/Twitter/PNScore/negative`
    end
  end
end
