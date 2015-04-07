Spree::LineItem.class_eval do
  has_one :gift_card, class_name: 'Spree::GiftCard'

  def gift_card?
    product.gift_card?
  end

  # Update with 3-0-stable
  def options=(options={})
    return unless options.present?

    opts = options.dup # we will be deleting from the hash, so leave the caller's copy intact

    currency = opts.delete(:currency) || order.try(:currency)

    # delete gift card from options
    # and generates gift_card from
    # self line_item
    gift_card_data = opts.delete('gift_card') || opts.delete(:gift_card)

    if gift_card? and gift_card_data
      line_gift_card = self.gift_card || self.build_gift_card
      line_gift_card.data = gift_card_data
    end

    if currency
      self.currency = currency
      self.price    = variant.price_in(currency).amount +
                      variant.price_modifier_amount_in(currency, opts)
    else
      self.price    = variant.price +
                      variant.price_modifier_amount(opts)
    end

    self.assign_attributes opts
  end

  def validate_gift_card_data
    if gift_card and !gift_card.valid?
      errors.add(:gift_card_data, "invalid")
    end
  end
end
