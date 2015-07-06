# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150704100923) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string   "comment",    null: false
    t.integer  "plant_id"
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["plant_id"], name: "index_comments_on_plant_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "done_tasks", force: :cascade do |t|
    t.integer  "task_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.boolean  "skipped",    default: false,                 null: false
    t.datetime "date",       default: '2015-05-04 09:32:25', null: false
    t.datetime "deleted_at"
    t.string   "notice"
  end

  add_index "done_tasks", ["deleted_at"], name: "index_done_tasks_on_deleted_at", using: :btree
  add_index "done_tasks", ["task_id"], name: "index_done_tasks_on_task_id", using: :btree

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
    t.float    "ph"
  end

  add_index "plants", ["cached_votes_total"], name: "index_plants_on_cached_votes_total", using: :btree
  add_index "plants", ["deleted_at"], name: "index_plants_on_deleted_at", using: :btree
  add_index "plants", ["user_id"], name: "index_plants_on_user_id", using: :btree

  create_table "seasons", force: :cascade do |t|
    t.integer  "season",     null: false
    t.date     "start",      null: false
    t.date     "stop",       null: false
    t.integer  "region",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  add_index "tasks", ["deleted_at"], name: "index_tasks_on_deleted_at", using: :btree
  add_index "tasks", ["plant_id"], name: "index_tasks_on_plant_id", using: :btree
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
