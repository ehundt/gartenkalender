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

ActiveRecord::Schema.define(version: 20150417092238) do

  create_table "done_tasks", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "season",     null: false
    t.integer  "year",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "done_tasks", ["task_id"], name: "index_done_tasks_on_task_id"

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
    t.boolean  "active",                  default: true, null: false
    t.integer  "user_id"
  end

  add_index "plants", ["user_id"], name: "index_plants_on_user_id"

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
    t.integer  "user_id"
    t.boolean  "hide",       default: false, null: false
  end

  add_index "tasks", ["plant_id"], name: "index_tasks_on_plant_id"
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id"

  create_table "user_connections", force: :cascade do |t|
    t.integer  "requesting_user_id"
    t.integer  "sharing_user_id"
    t.boolean  "confirmed"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "user_connections", ["requesting_user_id"], name: "index_user_connections_on_requesting_user_id"
  add_index "user_connections", ["sharing_user_id"], name: "index_user_connections_on_sharing_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "admin"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
