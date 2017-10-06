class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    if user_signed_in?
      policy_name = exception.policy.class.to_s.underscore
      flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
      redirect_to root_path
    else
      flash[:error] = 'You have to log in first'
      redirect_to user_google_oauth2_omniauth_authorize_path
    end
  end
end
