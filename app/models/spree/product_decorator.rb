Spree::Product.class_eval do
  def gift_card?
    gift_card.present?
  end
end
