class FootballMatchesController < ApplicationController
  def index
    render locals: { football_matches: FootballMatch.includes(:away_team, :home_team)}
  end
end
