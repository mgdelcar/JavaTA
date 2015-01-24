class AddProblemRefsToSubmissionTestResults < ActiveRecord::Migration
  def change
    add_reference :submission_test_results, :problem, index: true
  end
end