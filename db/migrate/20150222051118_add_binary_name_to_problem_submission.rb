class AddBinaryNameToProblemSubmission < ActiveRecord::Migration
  def change
    add_column :problem_submissions, :binary_name, :string
  end
end
