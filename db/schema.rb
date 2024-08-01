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

ActiveRecord::Schema[7.1].define(version: 2024_08_01_193314) do
  create_table "uploaded_companies", force: :cascade do |t|
    t.integer "uploaded_file_id"
    t.string "name"
    t.string "additional_name"
    t.string "site"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.float "coordinates_x"
    t.float "coordinates_y"
    t.string "comment"
    t.string "category_code"
    t.boolean "active"
    t.integer "request_status"
    t.boolean "request_success"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uploaded_file_id"], name: "index_uploaded_companies_on_uploaded_file_id"
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string "name"
    t.string "content_type"
    t.integer "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "password_digest"
    t.string "okdesk_account"
    t.string "okdesk_api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "uploaded_companies", "uploaded_files"
end
