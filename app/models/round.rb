class Round < ApplicationRecord
  has_many :football_matches
  has_many :bets, through: :football_matches
  has_many :users, through: :bets

  def user_score(user_id)
    bets.where(user_id: user_id).sum(:point)
  end

  def winner
    users.select('users.*',
                 'SUM(bets.point) AS round_points',
                 'COUNT(bets.id) FILTER (WHERE bets.point = 3) AS number_of_correct_bets',
                 'SUM(ABS(bets.home_team_score - football_matches.home_team_score) + ' \
                   'ABS(bets.away_team_score - football_matches.away_team_score)) AS goal_difference')
         .group(:id)
         .order('round_points DESC', 'number_of_correct_bets DESC', 'goal_difference ASC')
         .first
  end
end
