Spree::User.class_eval do
  has_many :gift_cards, class_name: 'Spree::GiftCard'
end
