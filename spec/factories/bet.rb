FactoryGirl.define do
  factory :bet do
    user
    football_match
    home_team_score 0
    away_team_score 0
  end
end
