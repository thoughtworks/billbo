# encoding: UTF-8

ENV['MONGO_TST_URI'] ||= 'mongodb://localhost/billbo_test'
Mongoid.load!('./config/mongoid.yml')
