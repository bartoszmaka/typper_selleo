class BetForm < Patterns::Form
  param_key 'bet'

  attribute :football_match_id, Integer
  attribute :user_id, Integer
  attribute :away_team_score, Integer
  attribute :home_team_score, Integer

  validates_presence_of :football_match_id, :user_id
  validates :away_team_score, numericality: { greater_than_or_equal_to: 0 }
  validates :home_team_score, numericality: { greater_than_or_equal_to: 0 }

  private

  def persist
    resource.update_attributes(attributes)
  end
end
