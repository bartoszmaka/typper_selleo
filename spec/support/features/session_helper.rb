module Features
  module SessionHelper
    def oauth_login_user(email:)
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new(
        provider: 'google',
        uid: '12345678910',
        info: {
          email: email.to_s
        },
        credentials: {
          token: 'abcdefg12345',
          refresh_token: '12345abcdefg',
          expires_at: DateTime.now
        }
      )
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] # If using Devise
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:default]
      visit user_google_oauth2_omniauth_authorize_path
      OmniAuth.config.mock_auth[:default][:info][:email]
    end
  end
end
