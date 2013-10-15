# encoding: UTF-8
module Sinatra
  module PermissionHelper
    def authentication_required_for(url, method)
      set(:method) do |method|
        method = method.to_s.upcase
        condition { request.request_method == method }
      end

      before url, :method => method do
        redirect('/', 401) if !logged_in
      end
    end
  end
  register PermissionHelper
end