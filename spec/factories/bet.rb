FactoryGirl.define do
  factory :bet do
    user
    football_match
    score_home 0
    score_away 0
  end
end
