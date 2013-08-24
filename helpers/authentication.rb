# encoding: UTF-8

def logged_in
  session[:email].present?
end

def logged_as_admin?
  logged_in && Admin.where(email: session[:email]).any?
end
