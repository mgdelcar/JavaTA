class RemoveIterationFromProblemSubmissions < ActiveRecord::Migration
  def change
    remove_column :problem_submissions, :iteration, :integer
  end
end
