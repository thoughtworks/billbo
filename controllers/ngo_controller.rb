# encoding: UTF-8

get '/ngo/:id' do
  @ngo = Ngo.find(params[:id])
  erb :"/ngo/index", locals: { errors: [] }
end
