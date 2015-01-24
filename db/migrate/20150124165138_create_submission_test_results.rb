class CreateSubmissionTestResults < ActiveRecord::Migration
  def change
    drop_table :submission_test_results if table_exists? :submission_test_results
    
    create_table :submission_test_results do |t|
      t.integer :execution_time_in_ms
      t.string :output
      t.string :errors_output
      t.string :feedback
      t.boolean :terminates?
      t.integer :return_state
      t.integer :execution_result
      t.references :test_case, index: true
      t.references :problem_submission, index: true

      t.timestamps
    end
  end
end
