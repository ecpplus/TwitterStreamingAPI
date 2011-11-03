class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   "screen_name",                            :null => false
      t.string   "name"
      t.string   "description"
      t.string   "access_token"
      t.string   "access_token_secret"
      t.string   "profile_image_url"
      t.integer  "twitter_id",                             :null => false
      t.boolean  "followed",            :default => false, :null => false
      t.boolean  "removed",             :default => false, :null => false
      t.datetime "created_at",                             :null => false
      t.datetime "updated_at",                             :null => false
    end
    add_index "users", ["screen_name"], :name => "index_users_on_screen_name"
    add_index "users", ["twitter_id"], :name => "index_users_on_twitter_id"
  end
end
