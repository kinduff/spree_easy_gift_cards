Spree::LineItem.class_eval do
  has_one :gift_card, class_name: 'Spree::GiftCard'

  def gift_card?
    product.gift_card?
  end
end
