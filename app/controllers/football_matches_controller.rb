class FootballMatchesController < ApplicationController
  def index
    rounds = Round.includes(football_matches: { bets: :user, home_team: nil, away_team: nil })
    render locals: { rounds: rounds.page(params[:page] || Round.current_page) }
  end

  def create
    ImportMatches.call
    redirect_to root_path
  end
end
