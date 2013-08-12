class Admin
  include Mongoid::Document

  attr_accessible :email

  field :email, type: String

  validates :email, uniqueness: true, presence: true

  def exists?(email)
    Admin.where(email: email).count > 0
  end
end