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

ActiveRecord::Schema.define(version: 20151105200950) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string   "name"
    t.string   "zone"
    t.integer  "person_one"
    t.integer  "person_two"
    t.integer  "person_three"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.integer  "unit_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "category"
    t.string   "languages",               array: true
    t.integer  "quantities",              array: true
    t.integer  "limits",                  array: true
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "companionship_number"
    t.integer  "ordering_missionary_number"
    t.datetime "time_stamp"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "fulfilled"
    t.string   "orderJSON"
    t.string   "fulfilledJSON"
  end

  create_table "people", force: :cascade do |t|
    t.integer  "person_type"
    t.string   "name"
    t.string   "user_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
  end

end
