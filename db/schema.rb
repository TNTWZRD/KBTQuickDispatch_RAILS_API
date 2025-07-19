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

ActiveRecord::Schema[8.0].define(version: 2025_07_13_222046) do
  create_table "drivers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "status", default: 1
    t.string "reg_code"
    t.bigint "user_id"
    t.boolean "reports_enabled", default: true
    t.string "phone_number", null: false
    t.string "emergency_contact_names"
    t.string "emergency_contact_numbers"
    t.index ["name"], name: "index_drivers_on_name", unique: true
    t.index ["user_id"], name: "index_drivers_on_user_id"
  end

  create_table "shifts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "driver_id", null: false
    t.bigint "vehicle_id", null: false
    t.datetime "end_time"
    t.boolean "status", default: true, null: false
    t.datetime "cleared_at"
    t.datetime "last_cleared_at"
    t.decimal "bankroll_borrowed", precision: 10, scale: 2
    t.boolean "reports_enabled", default: true, null: false
    t.string "previous_vehicles"
    t.index ["driver_id"], name: "index_shifts_on_driver_id"
    t.index ["vehicle_id"], name: "index_shifts_on_vehicle_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", default: "", null: false
    t.integer "role", default: 0, null: false
    t.string "phone_number", default: "", null: false
    t.integer "status", default: 0, null: false
    t.integer "driver_id"
    t.boolean "darkmode", default: false, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.string "online_status"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "vehicles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nickname", null: false
    t.string "vin_number"
    t.string "license_plate"
    t.string "make"
    t.string "model"
    t.string "year"
    t.string "color"
    t.string "description"
    t.string "short_notes"
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["license_plate"], name: "index_vehicles_on_license_plate", unique: true
    t.index ["nickname"], name: "index_vehicles_on_nickname", unique: true
    t.index ["vin_number"], name: "index_vehicles_on_vin_number", unique: true
  end

  add_foreign_key "shifts", "drivers"
  add_foreign_key "shifts", "vehicles"
end
