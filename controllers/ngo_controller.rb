# encoding: UTF-8

get '/ngo/:id' do
  @ngo = Ngo.find(params[:id])
  erb :"/ngo/index", locals: { errors: [] }
end

get "/ngo/:id/share" do
  @ngo = Ngo.find(params[:id])
  erb :"/ngo/share", locals: { errors: [] }
end