# spec/factories/carts.rb
FactoryBot.define do
  factory :cart, aliases: [:shopping_cart] do
    status { :active }
    last_interaction_at { Time.current }
    total_price { 0.0 }
    
    trait :active_recent do
      status { :active }
      last_interaction_at { 1.hour.ago }
    end
    
    trait :active_old do
      status { :active }
      last_interaction_at { 4.hours.ago }
    end
    
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