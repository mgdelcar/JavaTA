class User < ActiveRecord::Base
  enum user_type: [ :student, :instructor, :admininstrator ]
end
