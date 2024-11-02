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

ActiveRecord::Schema[7.0].define(version: 2024_10_08_023601) do
  create_table "asset_contacts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "assignable_type", null: false
    t.integer "assignable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignable_type", "assignable_id"], name: "index_asset_contacts_on_assignable"
    t.index ["user_id"], name: "index_asset_contacts_on_user_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name"
    t.string "number"
    t.string "street", null: false
    t.string "city", null: false
    t.string "state"
    t.string "zip5"
    t.integer "bbl"
    t.integer "bin"
    t.integer "portfolio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_buildings_on_portfolio_id"
  end

  create_table "complaints", force: :cascade do |t|
    t.string "complaint_id"
    t.datetime "filed_date"
    t.string "description"
    t.string "category_code"
    t.datetime "inspection_date"
    t.string "link"
    t.integer "state", default: 0
    t.integer "severity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "building_id"
    t.datetime "disposition_date"
    t.string "disposition_code"
    t.index ["building_id"], name: "index_complaints_on_building_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "inspections", force: :cascade do |t|
    t.integer "state", default: 0
    t.string "comment"
    t.integer "building_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_inspections_on_building_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "email_address"
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_portfolios_on_organization_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "sms"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "admin"
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "violations", force: :cascade do |t|
    t.string "violation_id"
    t.integer "state", default: 0
    t.datetime "issue_date"
    t.integer "severity"
    t.string "violation_type"
    t.string "description"
    t.string "device_number"
    t.string "device_type"
    t.integer "building_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_violations_on_building_id"
  end

  add_foreign_key "asset_contacts", "users"
  add_foreign_key "buildings", "portfolios"
  add_foreign_key "complaints", "buildings"
  add_foreign_key "inspections", "buildings"
  add_foreign_key "portfolios", "organizations"
  add_foreign_key "users", "organizations"
  add_foreign_key "violations", "buildings"
end
