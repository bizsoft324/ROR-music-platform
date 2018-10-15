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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170607031917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", force: :cascade do |t|
    t.integer  "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.jsonb    "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time", using: :btree
    t.index ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name", using: :btree
    t.index ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name", using: :btree
  end

  create_table "artist_subdomains", force: :cascade do |t|
    t.string  "domain"
    t.string  "slug"
    t.integer "user_id"
    t.index ["slug"], name: "index_artist_subdomains_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_artist_subdomains_on_user_id", using: :btree
  end

  create_table "artist_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_artist_types_on_name", unique: true, using: :btree
  end

  create_table "badges", force: :cascade do |t|
    t.text     "description"
    t.integer  "badge_duty_id"
    t.string   "badge_duty_type"
    t.datetime "date_granted",    null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "critique_id",      null: false
    t.integer  "user_id",          null: false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
    t.index ["critique_id"], name: "index_comments_on_critique_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "critiques", force: :cascade do |t|
    t.integer  "track_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_id"], name: "index_critiques_on_track_id", using: :btree
  end

  create_table "genres", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true, using: :btree
  end

  create_table "genres_tracks", id: false, force: :cascade do |t|
    t.integer "genre_id"
    t.integer "track_id"
    t.index ["genre_id", "track_id"], name: "index_genres_tracks_on_genre_id_and_track_id", unique: true, using: :btree
    t.index ["genre_id"], name: "index_genres_tracks_on_genre_id", using: :btree
    t.index ["track_id"], name: "index_genres_tracks_on_track_id", using: :btree
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id",             null: false
    t.string   "uid"
    t.string   "avatar_url"
    t.string   "refresh_token"
    t.string   "access_token_secret"
    t.string   "provider",            null: false
    t.string   "access_token",        null: false
    t.datetime "expires_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["provider", "uid"], name: "index_identities_on_provider_and_uid", using: :btree
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "track_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
    t.index ["user_id", "track_id"], name: "index_ratings_on_user_id_and_track_id", unique: true, using: :btree
  end

  create_table "shortened_urls", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type", limit: 20
    t.text     "url",                               null: false
    t.string   "unique_key", limit: 10,             null: false
    t.integer  "use_count",             default: 0, null: false
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_shortened_urls_on_owner_id_and_owner_type", using: :btree
    t.index ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true, using: :btree
    t.index ["url"], name: "index_shortened_urls_on_url", using: :btree
  end

  create_table "soundbites", force: :cascade do |t|
    t.integer  "comment_id"
    t.integer  "critique_id"
    t.string   "data_url"
    t.integer  "data_id"
    t.integer  "data_start"
    t.integer  "data_end"
    t.integer  "data_plays"
    t.string   "title"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["comment_id"], name: "index_soundbites_on_comment_id", using: :btree
    t.index ["critique_id"], name: "index_soundbites_on_critique_id", using: :btree
  end

  create_table "subgenres", force: :cascade do |t|
    t.string   "name"
    t.integer  "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_subgenres_on_genre_id", using: :btree
    t.index ["name"], name: "index_subgenres_on_name", unique: true, using: :btree
  end

  create_table "subgenres_tracks", id: false, force: :cascade do |t|
    t.integer "subgenre_id"
    t.integer "track_id"
    t.index ["subgenre_id", "track_id"], name: "index_subgenres_tracks_on_subgenre_id_and_track_id", unique: true, using: :btree
    t.index ["subgenre_id"], name: "index_subgenres_tracks_on_subgenre_id", using: :btree
    t.index ["track_id"], name: "index_subgenres_tracks_on_track_id", using: :btree
  end

  create_table "track_charted", force: :cascade do |t|
    t.integer  "track_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "week"
    t.integer  "day"
    t.datetime "date"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "position"
    t.integer  "previous_position"
    t.string   "type"
  end

  create_table "tracks", force: :cascade do |t|
    t.integer  "user_id",                            null: false
    t.string   "soundcloud_uri"
    t.string   "artwork_url"
    t.string   "permalink"
    t.text     "description"
    t.integer  "duration"
    t.boolean  "sharing",            default: false
    t.boolean  "commentable",        default: true
    t.boolean  "streamable",         default: true
    t.boolean  "downloadable",       default: false
    t.boolean  "has_vocals",         default: false
    t.boolean  "has_samples",        default: false
    t.string   "title"
    t.boolean  "marked",             default: false, null: false
    t.text     "audio_data"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "artist_type_id"
    t.string   "cover"
    t.float    "rating",             default: 0.0
    t.integer  "social_shares",      default: 0
    t.float    "waveform",           default: [],                 array: true
    t.boolean  "has_beat_switch"
    t.integer  "like_count",         default: 0
    t.integer  "indifferent_count",  default: 0
    t.integer  "dislike_count",      default: 0
    t.boolean  "contactable",        default: false
    t.boolean  "is_charted",         default: false
    t.text     "image_data"
    t.integer  "all_time_position"
    t.integer  "critiques_count",    default: 0
    t.text     "tag_list"
    t.jsonb    "previous_positions", default: {}
    t.index ["artist_type_id"], name: "index_tracks_on_artist_type_id", using: :btree
    t.index ["contactable"], name: "index_tracks_on_contactable", using: :btree
    t.index ["has_samples"], name: "index_tracks_on_has_samples", using: :btree
    t.index ["has_vocals"], name: "index_tracks_on_has_vocals", using: :btree
    t.index ["rating"], name: "index_tracks_on_rating", using: :btree
    t.index ["user_id"], name: "index_tracks_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "country"
    t.string   "city"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "description"
    t.string   "token"
    t.string   "reset_password_token"
    t.datetime "last_activity_at"
    t.string   "avatar"
    t.boolean  "confirmed",              default: false
    t.string   "password_digest"
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
    t.text     "bio"
    t.string   "background_image"
    t.boolean  "is_visible",             default: true
    t.string   "slug"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.jsonb    "roles",                  default: "{ \"admin\": false, \"producer\": false }"
    t.boolean  "admin",                  default: false,                                       null: false
    t.jsonb    "email_data",             default: {}
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
    t.index ["roles"], name: "index_users_on_roles", using: :gin
    t.index ["token"], name: "index_users_on_token", using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id", using: :btree
    t.index ["visit_token"], name: "index_visits_on_visit_token", unique: true, using: :btree
  end

end
