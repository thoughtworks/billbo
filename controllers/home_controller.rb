# encoding: UTF-8

get '/' do
  @ngos = Ngo.all
  erb :"/home/index"
end
