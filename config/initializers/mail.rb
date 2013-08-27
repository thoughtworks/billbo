# encoding: UTF-8

Pony.options = {
  :via => :smtp,
  :via_options => {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => ENV['billbo_login'],
    :password             => ENV['billbo_password'],
    :authentication       => :plain,
    :domain               => "localhost.localdomain"
  }
}
