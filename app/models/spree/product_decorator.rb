Spree::Product.class_eval do
  has_one :gift_card, class_name: 'Spree::GiftCard'

  def gift_card?
    gift_card.present?
  end
end
