Spree::User.class_eval do
  def gift_cards
    orders.gift_cards
  end
end
