# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101207151356) do

  create_table "ad_dynamics", :id => false, :force => true do |t|
    t.integer "ad_id"
    t.integer "campaign_id"
    t.integer "platform_id"
    t.integer "city_id"
    t.integer "sex"
    t.integer "min_age"
    t.integer "max_age"
    t.integer "ad_type"
    t.string  "name"
    t.string  "description"
    t.string  "image_url"
    t.string  "link"
    t.decimal "click_cost",  :precision => 18, :scale => 9
    t.integer "clicks"
    t.decimal "ctr",         :precision => 18, :scale => 9
    t.decimal "rand",        :precision => 18, :scale => 9
  end

  create_table "ads", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "min_age",                                                   :default => 0
    t.integer  "max_age",                                                   :default => 999
    t.integer  "sex",                                                       :default => 0
    t.integer  "city",                                                      :default => 0
    t.decimal  "click_cost",                 :precision => 10, :scale => 0, :default => 1
    t.integer  "views",                                                     :default => 0
    t.integer  "clicks",                                                    :default => 0
    t.decimal  "expenses",                   :precision => 10, :scale => 0, :default => 0
    t.integer  "status",                                                    :default => 0
    t.string   "link"
    t.string   "image_url"
    t.string   "name",        :limit => 50
    t.string   "description", :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ad_type",                                                   :default => 0
  end

  add_index "ads", ["campaign_id"], :name => "index_ads_on_campaign_id"

  create_table "ads_cities", :id => false, :force => true do |t|
    t.integer "ad_id"
    t.integer "city_id"
  end

  add_index "ads_cities", ["ad_id", "city_id"], :name => "index_ads_cities_on_ad_id_and_city_id"

  create_table "ads_platforms", :id => false, :force => true do |t|
    t.integer "ad_id"
    t.integer "platform_id"
  end

  add_index "ads_platforms", ["ad_id", "platform_id"], :name => "index_ads_platforms_on_ad_id_and_platform_id"

  create_table "campaigns", :force => true do |t|
    t.integer  "member_id"
    t.string   "name"
    t.integer  "status",                                    :default => 0
    t.decimal  "balance",    :precision => 10, :scale => 0, :default => 0
    t.decimal  "limit",      :precision => 10, :scale => 0, :default => -1
    t.decimal  "day_limit",  :precision => 10, :scale => 0, :default => -1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaigns", ["member_id"], :name => "index_campaigns_on_member_id"

  create_table "cities", :force => true do |t|
    t.integer "country_id"
    t.string  "name"
  end

  add_index "cities", ["country_id"], :name => "index_cities_on_country_id"

  create_table "countries", :force => true do |t|
    t.string "name"
  end

  create_table "members", :force => true do |t|
    t.string   "login"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "name"
    t.decimal  "balance",         :precision => 10, :scale => 0, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["login"], :name => "index_members_on_login"

  create_table "platforms", :force => true do |t|
    t.integer  "member_id"
    t.string   "name"
    t.integer  "views",                                     :default => 0
    t.integer  "clicks",                                    :default => 0
    t.decimal  "earnings",   :precision => 10, :scale => 0, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "platforms", ["member_id"], :name => "index_platforms_on_member_id"

  create_table "statistic_entries", :force => true do |t|
    t.integer  "platform_id"
    t.integer  "ad_id"
    t.integer  "year"
    t.integer  "day"
    t.integer  "month"
    t.decimal  "expenses",    :precision => 10, :scale => 0
    t.integer  "views"
    t.integer  "clicks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
