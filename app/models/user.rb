class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :username, :on => :create  
  has_many :comments
  has_many :follows
  belongs_to :company
end
