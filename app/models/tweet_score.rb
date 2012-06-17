class TweetScore
  include Mongoid::Document
  field :positive, type: Integer, default: 0
  field :negative, type: Integer, default: 0
  field :created_at, null: false
  index :created_at
end
