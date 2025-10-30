FactoryBot.define do
  factory :cart do
    total_price { 0.0 }
    last_interaction_at { Time.current }
    status { :active }
  end
end