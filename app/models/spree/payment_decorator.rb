Spree::Payment.class_eval do
  state_machine do
    # once payment is complete aka order.payment_state = 'paid' ship
    # digital shipments if auto_ship_digital_shipments? is set to true
    after_transition :on => :complete, :do => :ship_digital_shipments, if: :auto_ship_digital_shipments?
  end

  def ship_digital_shipments
    order.shipments.digitals.each do |digital_shipment|
      digital_shipment.try(:ship) # let's avoid exceptions here
    end
  end

  def auto_ship_digital_shipments?
    SpreeEasyGiftCards.auto_ship_digital_shipments
  end
end
