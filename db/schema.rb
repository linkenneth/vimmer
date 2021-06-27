# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_27_190640) do

  create_table "follows", force: :cascade do |t|
    t.integer "following_user_id"
    t.integer "followed_user_id"
    t.index ["followed_user_id"], name: "index_follows_on_followed_user_id"
    t.index ["following_user_id"], name: "index_follows_on_following_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.string "likable_type", default: "Post"
    t.integer "likable_id"
    t.integer "user_id"
    t.index ["likable_type", "likable_id"], name: "index_likes_on_likable"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "title"
    t.text "content"
    t.integer "user_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "encrypted_password"
  end

  add_foreign_key "follows", "users", column: "followed_user_id"
  add_foreign_key "follows", "users", column: "following_user_id"
end
