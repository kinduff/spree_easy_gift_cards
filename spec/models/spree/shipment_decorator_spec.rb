require 'spec_helper'

describe Spree::Shipment, :type => :model do
  let(:order) { Spree::Order.create }

  let(:shipping_method) { create(:shipping_method, name: 'Digital', admin_name: 'Digital') }

  let(:shipment) do
    shipment = Spree::Shipment.create(cost: 1, state: 'ready')
    shipment.shipping_methods = [shipping_method]
    shipment.save
    shipment
  end

  it "should return digital shipments" do
    order.shipments = [shipment]
    expect(order.shipments.digitals.first.shipping_method).to eq(shipping_method)
  end
end
