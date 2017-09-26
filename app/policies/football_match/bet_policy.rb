class FootballMatch::BetPolicy < ApplicationPolicy
  def new?
    manage_bet?
  end

  def show?
    correct_user?
  end

  def edit?
    manage_bet? && correct_user?
  end

  def create?
    manage_bet?
  end

  def update?
    manage_bet? && correct_user?
  end

  def destroy?
    manage_bet? && correct_user?
  end

  private

  def correct_user?
    resource[1]&.user == user
  end

  def manage_bet?
    resource[0]&.can_place_bet?
  end
end
