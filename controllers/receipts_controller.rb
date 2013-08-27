# encoding: UTF-8

get '/bills/:bill_id/receipts/new' do
  @bill = Bill.find(params[:bill_id])
  erb :"/receipts/new", locals: { errors: [] }
end

post '/bills/:bill_id/receipts/create' do
  @bill = Bill.find(params[:bill_id])
  receipt = @bill.create_receipt(params)

  if receipt.persisted?
    send_email(receipt, @bill)
    redirect '/', :success => I18n.t(:upload_receipt_ok)
  else
    erb :"receipts/new", locals: { errors: receipt.errors.full_messages }
  end
end

private

# FIXME this should not be here
def send_email(payment, bill)
  recipients = Admin.pluck(:email).join(",")
  Pony.mail(:to => recipients,
            :from => payment.contributor_email,
            :subject => I18n.t(:upload_receipt_subject),
            :html_body => erb(:"/mails/payment_confirmation",
                              :locals => {:receipt => payment, :bill => bill },
                              :layout => false),
                              :via => :smtp)

end
