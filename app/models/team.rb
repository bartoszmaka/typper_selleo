class Team < ApplicationRecord

  has_many :away_matches, class_name: 'FootballMatch', foreign_key: 'away_team_id'
  has_many :home_matches, class_name: 'FootballMatch', foreign_key: 'home_team_id'

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
