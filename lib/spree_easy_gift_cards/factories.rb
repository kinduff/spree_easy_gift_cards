FactoryGirl.define do
  factory :gift_card, class: Spree::GiftCard do
    product
    data {}
    user
    order
  end
end
