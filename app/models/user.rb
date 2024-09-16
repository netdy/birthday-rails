class User < ApplicationRecord
  has_many :people
  has_secure_password
end
