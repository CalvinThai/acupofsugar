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

ActiveRecord::Schema.define(version: 2018_11_06_213142) do

  create_table "borrowed_items", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.date "due_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_borrowed_items_on_item_id"
    t.index ["user_id"], name: "index_borrowed_items_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.string "friendable_type"
    t.integer "friendable_id"
    t.integer "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "blocker_id"
    t.integer "status"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.text "descr"
    t.string "status", default: "available", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "on_hold_items", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.date "req_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "approved", default: "pending", null: false
    t.index ["item_id"], name: "index_on_hold_items_on_item_id"
    t.index ["user_id"], name: "index_on_hold_items_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "fname", null: false
    t.string "lname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_confirmed", default: true
    t.string "confirm_token"
  end

  create_table "wish_lists", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_wish_lists_on_item_id"
    t.index ["user_id"], name: "index_wish_lists_on_user_id"
  end

end
