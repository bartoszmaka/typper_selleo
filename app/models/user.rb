class User < ApplicationRecord
  devise :database_authenticatable,
         :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by(email: data['email'])
    unless user
      user = User.create(email: data['email'], password: Devise.friendly_token[0, 20])
    end
    user
  end
end
