class AddFieldsToProblemSubmission < ActiveRecord::Migration
  def change
    add_column :problem_submissions, :package_name, :string, :null => false, :default => ''
    add_column :problem_submissions, :relative_location, :string, :null => false, :default => ''
    change_column :problem_submissions, :binary_name, :string, :null => false, :default => ''
  end
end
