class SourceFile < ActiveRecord::Base
  belongs_to :problem_submission
  has_many :comments

  def absolute_path
    root_path = File.dirname(problem_submission.code.path)
    File.join(root_path, relative_path)
  end
end
