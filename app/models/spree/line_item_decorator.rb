Spree::LineItem.class_eval do
  def gift_card?
    product.gift_card?
  end
end
