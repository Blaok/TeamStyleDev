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

ActiveRecord::Schema.define(version: 20140214075504) do

  create_table "assignments", force: true do |t|
    t.string   "name"
    t.text     "information"
    t.integer  "course_id"
    t.datetime "startat"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "name"
    t.text     "information"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "courses_users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.integer  "user_id"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", force: true do |t|
    t.string   "name"
    t.text     "information"
    t.string   "path"
    t.string   "category"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assignment_id"
  end

  create_table "users", force: true do |t|
    t.integer  "administration"
    t.string   "salt"
    t.string   "hashed_password"
    t.string   "name"
    t.boolean  "gender"
    t.string   "class_name"
    t.string   "email"
    t.integer  "renren"
    t.integer  "qq"
    t.integer  "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "true_name"
  end

end
