class AddUserReferenceToProblemSubmissions < ActiveRecord::Migration
  def change
    add_column :problem_submissions, :user_id, :integer
    add_index :problem_submissions, :user_id
  end
end
