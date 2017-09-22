FactoryGirl.define do
  factory :football_match do
    match_date DateTime.parse('20.09.2013')
    home_team 'Barcelona'
    away_team 'Real Madrid'
    home_team_score 0
    away_team_score 22
  end
end
