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

ActiveRecord::Schema.define(version: 20150316195913) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rucoms", primary_key: "idrucom", force: true do |t|
    t.text     "record"
    t.text     "name"
    t.text     "status"
    t.text     "mineral"
    t.text     "location"
    t.text     "subcontract_number"
    t.text     "mining_permit"
    t.datetime "updated_at",         default: "now()"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "document_number"
    t.date     "document_expedition_date"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
  end

end
