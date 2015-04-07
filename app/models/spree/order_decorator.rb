Spree::Order.class_eval do
  scope :with_gift_cards, -> { includes(:products).select{|o| o.products.any?{|p| p.gift_card? } }.uniq }
  scope :gift_cards, -> { with_gift_cards.collect{|o| o.line_items.select(&:gift_card?) }.flatten.collect(&:gift_card) }

  def gift_cards
    line_items.gift_cards
  end
end
