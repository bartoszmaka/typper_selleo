class FootballMatchesController < ApplicationController
  def index
    render locals: { football_matches: FootballMatch.all }
  end
end
