# encoding: UTF-8

get '/share/:id' do
  @ngo = Ngo.find(params[:id])
  erb :"/share/index", locals: { errors: [] }
end