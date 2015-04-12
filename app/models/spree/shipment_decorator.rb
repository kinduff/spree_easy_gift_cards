Spree::Shipment.class_eval do
  scope :digitals, -> { joins(:shipping_methods).where(:spree_shipping_methods => { admin_name: 'Digital' }) }

  state_machine do
    after_transition to: :shipped, do: :send_gift_cards_emails, if: :digital?
  end

  def digital?
    shipping_method.admin_name == 'Digital'
  end

  private
    def send_gift_cards_emails
      gift_cards = inventory_units.includes(:line_item).collect(&:line_item)
      gift_cards.each do |gift_card|
        #GiftCardMailer.giftcard_email(gift_card).deliver_later
      end
    end
end
