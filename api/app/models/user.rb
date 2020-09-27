class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  has_many :visits
  has_many :locations, through: :visits
  has_secure_password
end
