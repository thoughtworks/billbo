# encoding: UTF-8

class Ngo 
  include Mongoid::Document
  
  field :name, type: String
  field :description, type: String
  field :phone, type: String
  field :website, type: String
  field :email, type: String
  field :contact, type: String
  field :photo_url, type: String

end
