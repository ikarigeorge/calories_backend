FactoryGirl.define do
  factory :meal do
    name { FFaker::Food.meat }
    date Date.current()
    time Time.current()
    calories 1400
    user
  end

end
