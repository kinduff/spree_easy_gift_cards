Spree::Shipment.class_eval do
  scope :digitals, -> { joins(:shipping_methods).where(:spree_shipping_methods => { admin_name: 'Digital' }) }

  private

    # Update with 3-0-stable
    def after_ship
      Spree::ShipmentHandler.factory(self).perform
      send_gift_cards_emails
    end

    # Adding this here to avoid modifying the ShipmentHandler perform action
    # ToDo: Write tests for this
    def send_gift_cards_emails
      gift_cards = inventory_units.includes(:line_item).collect(&:line_item)
      gift_cards.each do |gift_card|
        #GiftCardMailer.giftcard_email(gift_card).deliver_later
      end
    end
end
