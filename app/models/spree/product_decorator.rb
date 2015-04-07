Spree::Product.class_eval do
  def gift_card?
    self.slug == SpreeEasyGiftCards.gift_card_product
  end
end
