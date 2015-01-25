class Problem < ActiveRecord::Base
  has_many :test_cases
  
  def detect_plagiarism?
    detect_plagiarism ? 'Yes' : 'No'
  end
end
