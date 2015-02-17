class SourceFile < ActiveRecord::Base
  belongs_to :problem_submission
  has_many :comments
end
