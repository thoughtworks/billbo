# encoding: UTF-8

class Admin
  include Mongoid::Document

  attr_accessible :email

  field :email, type: String

  validates :email, uniqueness: true, presence: true
end
