class User < ActiveRecord::Base
  has_many :problem_submissions

  enum user_type: [ :student, :instructor, :admininstrator ]
end
