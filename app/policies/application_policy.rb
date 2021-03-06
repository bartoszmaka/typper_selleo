class ApplicationPolicy
  extend ActiveSupport::Autoload
  autoload :FootballMatch
  attr_reader :user, :resource

  def initialize(user, resource)
    raise Pundit::NotAuthorizedError unless user
    @user = user
    @resource = resource
  end
end
