Spree::Variant.class_eval do
  def gift_card?
    product.gift_card?
  end
end
