# encoding: UTF-8

class Ngo 
  include Mongoid::Document
  
  field :name, type: String
  field :admin, type: String
  field :phrase, type: String
  field :description, type: String
  
end