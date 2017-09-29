FactoryGirl.define do
  factory :football_match do
    match_date DateTime.new(2017, 9, 20, 12, 30)
    association :home_team, factory: :team
    association :away_team, factory: :team
    round

    trait :completed do
      home_team_score 2
      away_team_score 5
    end
  end
end
