class Bet < ApplicationRecord
  belongs_to :football_match
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [:football_match_id]
end
