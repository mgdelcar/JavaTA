class TestCase < ActiveRecord::Base
  belongs_to :problem
  has_many :submission_test_results
end
