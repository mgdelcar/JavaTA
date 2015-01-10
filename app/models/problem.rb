class Problem < ActiveRecord::Base
  def detect_plagiarism?
    detect_plagiarism ? 'Yes' : 'No'
  end
end
