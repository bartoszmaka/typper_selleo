class FootballMatchesController < ApplicationController
  def index
    render locals: { rounds: Round.includes(:football_matches, :bets, :users) }
  end

  def create
    ImportMatches.call
    redirect_to root_path
  end
end
