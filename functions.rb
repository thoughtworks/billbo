# encoding: UTF-8

# TODO This test-specific setup should not be here
def setup_user
  if ENV['RACK_ENV'] == 'test' && request.cookies["stub_email"]
    session[:email] = request.cookies["stub_email"]
  end
end

def h(text)
  Rack::Utils.escape_html text
end
