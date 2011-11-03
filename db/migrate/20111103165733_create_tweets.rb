class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer  :user_id,         :null => false
      t.string   :twitter_post_id, :null => false
      t.string   :text
      t.integer  :in_reply_to_user_id 
      t.timestamps :null => false
    end
    add_index :tweets, ["created_at"], :name => "index_tweets_on_created_at"
    add_index :tweets, ["user_id"],    :name => "index_tweets_on_user_id"
  end
end
