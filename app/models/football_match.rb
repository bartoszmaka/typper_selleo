class FootballMatch < ApplicationRecord
  has_many :bets
  belongs_to :away_team, class_name: Team.name
  belongs_to :home_team, class_name: Team.name
  belongs_to :round
  has_many :users, through: :bets

  def can_place_bet?
    match_date > (DateTime.now + 1.hour)
  end

  def current_user_bet(user)
    bets.find_by(user: user)
  end
end
