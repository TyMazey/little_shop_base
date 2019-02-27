FactoryBot.define do
  factory :coupon, class: Coupon do
    sequence(:name) { |n| "Coupon Name #{n}" }
    sequence(:value) { |n| ("#{n}".to_i + 1)* 10 }
  end
end
