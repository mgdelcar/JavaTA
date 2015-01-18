class ProblemSubmission < ActiveRecord::Base
  belongs_to :problem
  has_attached_file :code
  
  validates :code, :attachment_presence => true
  validates_attachment_content_type :code, :content_type => [/text.*\Z/, "application/octet-stream", "application/zip"]
  validates_attachment_file_name :code, :matches => [/java\Z/, /zip\Z/]
end
