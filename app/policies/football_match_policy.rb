class FootballMatchPolicy < ApplicationPolicy
  def new?
    manage_bet?
  end

  def edit?
    manage_bet?
  end

  def create?
    manage_bet?
  end

  def update?
    manage_bet?
  end

  def destroy?
    manage_bet?
  end

  private

  def manage_bet?
    resource.can_place_bet?
  end
end
