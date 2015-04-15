Spree::Shipment.class_eval do
  scope :digitals, -> { joins(:shipping_methods).where(:spree_shipping_methods => { admin_name: 'Digital' }) }

  state_machine do
    after_transition to: :shipped, do: :activate_gift_cards, if: :digital?
  end

  def digital?
    shipping_method.admin_name == 'Digital'
  end

  private
    def activate_gift_cards
      inventory_units.includes(:line_item).collect(&:line_item).map(&:gift_card).map(&:activate)
    end
end
