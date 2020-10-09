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

ActiveRecord::Schema.define(version: 20160428133006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string   "comment",    null: false
    t.integer  "plant_id"
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_id"], name: "index_comments_on_plant_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "done_tasks", force: :cascade do |t|
    t.integer  "task_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.datetime "date",       default: '2020-10-09 15:46:46', null: false
    t.datetime "deleted_at"
    t.string   "notice"
    t.integer  "plant_id"
    t.integer  "skipped"
    t.index ["deleted_at"], name: "index_done_tasks_on_deleted_at", using: :btree
    t.index ["plant_id"], name: "index_done_tasks_on_plant_id", using: :btree
    t.index ["task_id"], name: "index_done_tasks_on_task_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "plants", force: :cascade do |t|
    t.string   "name"
    t.string   "image_url"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size"
    t.datetime "main_image_updated_at"
    t.string   "subtitle"
    t.boolean  "active",                  default: true,  null: false
    t.integer  "user_id"
    t.integer  "creator_id"
    t.datetime "deleted_at"
    t.integer  "orig_id"
    t.boolean  "public",                  default: false, null: false
    t.integer  "category",                default: 0
    t.integer  "cached_votes_total",      default: 0
    t.text     "private_notes",           default: ""
    t.string   "location"
    t.string   "soil"
    t.float    "ph_from"
    t.float    "ph_to"
    t.string   "slug"
    t.integer  "duration"
    t.index ["cached_votes_total"], name: "index_plants_on_cached_votes_total", using: :btree
    t.index ["deleted_at"], name: "index_plants_on_deleted_at", using: :btree
    t.index ["slug"], name: "index_plants_on_slug", using: :btree
    t.index ["user_id"], name: "index_plants_on_user_id", using: :btree
  end

  create_table "seasons", force: :cascade do |t|
    t.integer  "season",     null: false
    t.date     "start",      null: false
    t.date     "stop",       null: false
    t.integer  "region",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_images", force: :cascade do |t|
    t.string   "title"
    t.string   "desc"
    t.integer  "task_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["task_id"], name: "index_task_images_on_task_id", using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.integer  "start",      default: 0
    t.integer  "stop",       default: 0
    t.text     "desc"
    t.integer  "repeat"
    t.integer  "plant_id",                   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hide",       default: false, null: false
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.date     "begin_date"
    t.date     "end_date"
    t.integer  "order"
    t.index ["deleted_at"], name: "index_tasks_on_deleted_at", using: :btree
    t.index ["plant_id"], name: "index_tasks_on_plant_id", using: :btree
    t.index ["user_id"], name: "index_tasks_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "admin",                  default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "slug"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["slug"], name: "index_users_on_slug", using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.string   "votable_type"
    t.integer  "votable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  end

end
