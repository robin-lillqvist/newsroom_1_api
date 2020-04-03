class User < ActiveRecord::Base
extend Devise::Models
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  validates_presence_of :role
  enum role: [:user, :journalist]
end
