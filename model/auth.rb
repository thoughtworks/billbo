class Auth
  GOOGLE_CLIENT_ID = "705027818305.apps.googleusercontent.com"
  GOOGLE_CLIENT_SECRET = "HuQQFanZJZZpwqVONjvE1aqX"

  attr_accessor :access_token, :email, :is_verified, :client

  def initialize(code = nil, redirect_uri = nil)
    unless code.nil?
      token = token_data(code, redirect_uri)

      @access_token = token[:access_token]
      @email = token[:email]
      @is_verified = token[:is_verified]
    end
  end

  def token_data(code, redirect_uri)
    token = client.auth_code.get_token(code, :redirect_uri => redirect_uri)

    {
      access_token: token.token,
      email: token.get('https://www.googleapis.com/userinfo/email?alt=json').parsed['data']['email'],
      is_verified: token.get('https://www.googleapis.com/userinfo/email?alt=json').parsed['data']['isVerified']
    }
  end

  def client
    @client ||= OAuth2::Client.new(Auth::GOOGLE_CLIENT_ID, Auth::GOOGLE_CLIENT_SECRET, {
      :site => "https://accounts.google.com",
      :authorize_url => "/o/oauth2/auth",
      :token_url => "/o/oauth2/token"
    })
  end

  def scopes
    'https://www.googleapis.com/auth/userinfo.email'
  end

  def authorize_url(redirect_uri)
    client.auth_code.authorize_url(:redirect_uri => redirect_uri, :scope => scopes, :access_type => "offline")
  end
end