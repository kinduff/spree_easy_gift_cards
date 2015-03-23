Spree::Shipment.class_eval do
  scope :digitals, -> { joins(:shipping_methods).where(:spree_shipping_methods => { admin_name: 'Digital' }) }
end
