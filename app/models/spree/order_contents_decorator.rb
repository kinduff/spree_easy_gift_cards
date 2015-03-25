Spree::OrderContents.class_eval do
  def add(variant, quantity = 1, options = {})
    line_item = variant.gift_card? ? add_gift_card_item(variant, quantity, options) : add_to_line_item(variant, quantity, options)
    after_add_or_remove(line_item, options)
  end

  private
    # Update with 3-0-stable
    def add_gift_card_item(variant, quantity, options = {})
      opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
                                          permit(Spree::PermittedAttributes.line_item_attributes)
      line_item = order.line_items.new(quantity: quantity,
                                        variant: variant,
                                        options: opts)
      line_item.save!
      line_item
    end
end
