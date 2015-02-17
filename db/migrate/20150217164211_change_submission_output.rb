class ChangeSubmissionOutput < ActiveRecord::Migration
  def change
    change_column :submission_test_results, :output, :text
    change_column :submission_test_results, :errors_output, :text
    change_column :submission_test_results, :feedback, :text
  end
end
