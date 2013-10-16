# encoding: UTF-8
module Sinatra
  module AuthenticationHelper
    def logged_in
      logged_in_email.present?
    end

    def logged_as_admin?
      logged_in && Admin.where(email: logged_in_email).any?
    end

    def logged_in_email
      session[:email] || ""
    end

  end

  helpers AuthenticationHelper
end
