class User < ActiveRecord::Base
  validates_presence_of :email, :full_name, :username
  validates_presence_of :password, on: :create
  validates_uniqueness_of :email, :username

  has_secure_password validations: false
end
