Spree::Promotion.class_eval do
  has_one :gift_card, class_name: 'Spree::GiftCard'
end
