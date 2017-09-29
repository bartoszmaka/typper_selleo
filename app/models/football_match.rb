class FootballMatch < ApplicationRecord
  belongs_to :away_team, class_name: Team.name
  belongs_to :home_team, class_name: Team.name
  belongs_to :round

  def can_place_bet?
    match_date > (DateTime.now + 1.hour)
  end
end
