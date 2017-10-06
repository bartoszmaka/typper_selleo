FactoryGirl.define do
  factory :user do
    sequence :email { |x| "example#{x}@selleo.com" }
    password 'password'
  end
end
