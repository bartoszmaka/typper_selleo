class FootballMatchesController < ApplicationController
  def index
    rounds = Round.includes(football_matches: { bets: :user, home_team: nil, away_team: nil }).order(number: :desc)

    render locals: { rounds: rounds }
  end

  def create
    ImportMatches.call
    redirect_to root_path
  end
end
