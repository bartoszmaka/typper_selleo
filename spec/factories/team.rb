FactoryGirl.define do
  factory :team do
    sequence :name { |x| "FC Arka#{x}" }
  end
end
