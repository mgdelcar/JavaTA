class Comment < ActiveRecord::Base
  belongs_to :source_file
  belongs_to :comment
  belongs_to :user
end
