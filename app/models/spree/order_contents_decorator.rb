Spree::OrderContents.class_eval do
  # Update with 3-0-stable
  def add_to_line_item(variant, quantity, options = {})
    line_item = grab_line_item_by_variant(variant, false, options)

    if line_item and !variant.gift_card?
      line_item.quantity += quantity.to_i
      line_item.currency = currency unless currency.nil?
    else
      opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
                                          permit(Spree::PermittedAttributes.line_item_attributes)
      line_item = order.line_items.new(quantity: quantity,
                                        variant: variant,
                                        options: opts)
    end
    line_item.target_shipment = options[:shipment] if options.has_key? :shipment
    line_item.save!
    line_item
  end
end
