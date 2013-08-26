# encoding: UTF-8

get '/bills/:bill_id/receipts/new' do
  @bill = Bill.find(params[:bill_id])
  erb :"/receipts/new"
end

post '/bills/:bill_id/receipts/create' do
  bill = Bill.find(params[:bill_id])
  receipt = bill.create_receipt(params)

  if receipt.persisted?
    send_email receipt, bill
    redirect '/', :success => I18n.t(:upload_receipt_ok)
  else
    redirect "/bills/#{bill.id}/receipts/new", :error => I18n.t(:upload_receipt_fail)
  end
end

private

# FIXME this should not be here
def send_email payment, bill
  Admin.all.each do |admin|
    Pony.mail :to => admin.email,
          :from => payment.contributor_email,
          :subject => I18n.t(:upload_receipt_subject),
          :html_body => erb(:"/mails/payment_confirmation",
                            :locals => {:receipt => payment, :bill => bill },
                            :layout => false),
          :via => :smtp

  end
end
