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

ActiveRecord::Schema.define(version: 20150226022307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "message"
    t.integer  "line_number"
    t.integer  "source_file_id"
    t.integer  "comment_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["comment_id"], name: "index_comments_on_comment_id", using: :btree
  add_index "comments", ["source_file_id"], name: "index_comments_on_source_file_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "problem_submissions", force: true do |t|
    t.datetime "when"
    t.integer  "problem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code_file_name"
    t.string   "code_content_type"
    t.integer  "code_file_size"
    t.datetime "code_updated_at"
    t.integer  "compilation_result"
    t.text     "compiler_stdout"
    t.text     "compiler_stderr"
    t.integer  "compiler_return_value"
    t.integer  "user_id"
    t.string   "binary_name",           default: "", null: false
    t.string   "package_name",          default: "", null: false
    t.string   "relative_location",     default: "", null: false
  end

  add_index "problem_submissions", ["problem_id"], name: "index_problem_submissions_on_problem_id", using: :btree
  add_index "problem_submissions", ["user_id"], name: "index_problem_submissions_on_user_id", using: :btree

  create_table "problems", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "detect_plagiarism"
    t.string   "language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "source_files", force: true do |t|
    t.string   "relative_path"
    t.text     "source_code"
    t.integer  "problem_submission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "source_files", ["problem_submission_id"], name: "index_source_files_on_problem_submission_id", using: :btree

  create_table "submission_test_results", force: true do |t|
    t.integer  "execution_time_in_ms"
    t.text     "output"
    t.text     "errors_output"
    t.text     "feedback"
    t.boolean  "terminates?"
    t.integer  "return_state"
    t.integer  "execution_result"
    t.integer  "test_case_id"
    t.integer  "problem_submission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "submission_test_results", ["problem_submission_id"], name: "index_submission_test_results_on_problem_submission_id", using: :btree
  add_index "submission_test_results", ["test_case_id"], name: "index_submission_test_results_on_test_case_id", using: :btree

  create_table "test_cases", force: true do |t|
    t.text     "input"
    t.text     "output"
    t.integer  "points"
    t.integer  "max_time_execution_sec"
    t.integer  "problem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "test_cases", ["problem_id"], name: "index_test_cases_on_problem_id", using: :btree

  create_table "tokens", force: true do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "last_name"
    t.integer  "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
