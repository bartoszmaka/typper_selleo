class ScoreboardsController < ApplicationController
  def index
    render locals: {
      users: UserDecorator.decorate_collection(User.all.sort_by(&:total_points).reverse!),
      rounds: Round.all
    }
  end
end
