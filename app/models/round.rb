class Round < ApplicationRecord
  has_many :football_matches

  def user_score(user_id)
    Bet.where(user_id: user_id, football_match: FootballMatch.where(round_id: id)).sum(:point)
  end
end
