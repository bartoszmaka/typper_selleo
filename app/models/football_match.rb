class FootballMatch < ApplicationRecord
  belongs_to :away_team, class_name: Team.name
  belongs_to :home_team, class_name: Team.name
end
