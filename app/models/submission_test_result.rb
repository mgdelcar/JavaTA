class SubmissionTestResult < ActiveRecord::Base
  belongs_to :test_case
  belongs_to :problem_submission

  enum execution_result: [ :created, :cancelled, :in_progress, :test_pass, :test_failed, :cannot_compile, :timeout ]
end
