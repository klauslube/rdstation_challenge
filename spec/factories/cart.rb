# spec/factories/carts.rb
FactoryBot.define do
  factory :cart, aliases: [:shopping_cart] do
    status { :active }
    last_interaction_at { Time.current }
    total_price { 0.0 }
    
    trait :abandoned do
      status { :abandoned }
      abandoned_at { 5.days.ago }
      last_interaction_at { 6.days.ago }
    end
    
    trait :over_abandoned do
      status { :abandoned }
      abandoned_at { 10.days.ago }
      last_interaction_at { 12.days.ago }
    end
  end
end