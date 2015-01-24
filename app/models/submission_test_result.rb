class SubmissionTestResult < ActiveRecord::Base
  belongs_to :test_case
  belongs_to :problem
end
