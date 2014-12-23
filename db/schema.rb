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

ActiveRecord::Schema.define(version: 20141223234748) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "problem_submissions", force: true do |t|
    t.string   "file_relative_path"
    t.integer  "iteration"
    t.datetime "when"
    t.integer  "problem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "problem_submissions", ["problem_id"], name: "index_problem_submissions_on_problem_id", using: :btree

  create_table "problems", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.boolean  "detect_plagiarism"
    t.string   "language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submission_test_results", force: true do |t|
    t.integer  "execution_time_in_ms"
    t.string   "output"
    t.string   "errors_output"
    t.string   "feedback"
    t.boolean  "terminates?"
    t.integer  "return_state"
    t.integer  "test_case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "submission_test_results", ["test_case_id"], name: "index_submission_test_results_on_test_case_id", using: :btree

  create_table "test_cases", force: true do |t|
    t.string   "input"
    t.string   "output"
    t.integer  "points"
    t.integer  "max_time_execution_sec"
    t.integer  "problem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "test_cases", ["problem_id"], name: "index_test_cases_on_problem_id", using: :btree

end
