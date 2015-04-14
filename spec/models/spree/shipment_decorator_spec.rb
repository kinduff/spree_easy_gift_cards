require 'spec_helper'

describe Spree::Shipment, :type => :model do
  let(:order) { Spree::Order.create }

  let(:shipping_method) { create(:shipping_method, name: 'Digital', admin_name: 'Digital') }
  let(:regular_shipping_method) { create(:shipping_method) }

  let(:shipment) do
    shipment = Spree::Shipment.create(cost: 1, state: 'ready')
    shipment.shipping_methods = [shipping_method]
    shipment.save
    shipment
  end

  let(:regular_shipment) do
    shipment = Spree::Shipment.create(cost: 1, state: 'ready')
    shipment.shipping_methods = [regular_shipping_method]
    shipment.save
    shipment
  end

  it "should return digital shipments" do
    order.shipments = [shipment]
    expect(order.shipments.digitals.first.shipping_method).to eq(shipping_method)
  end

  context :digital? do
    it "returns true if digital" do
      expect(shipment.digital?).to be_truthy
    end

    it "returns false if not digital" do
      expect(regular_shipment.digital?).to be_falsy
    end
  end

  context "when shipment state changes to shipped" do
    before do
      allow_any_instance_of(Spree::ShipmentHandler).to receive(:send_gift_cards_emails)
      allow_any_instance_of(Spree::ShipmentHandler).to receive(:send_shipped_email)
      allow_any_instance_of(Spree::ShipmentHandler).to receive(:update_order_shipment_state)
    end

    it "should call after_ship" do
      allow(shipment).to receive(:send_shipped_email)
      allow(shipment).to receive(:update_order_shipment_state)
      expect(shipment).to receive(:after_ship)
      shipment.ship!
    end

    it "should call send_gift_cards_emails" do
      allow(shipment).to receive(:send_shipped_email)
      allow(shipment).to receive(:update_order_shipment_state)
      allow(shipment).to receive(:after_ship)
      expect(shipment).to receive(:send_gift_cards_emails)
      shipment.ship!
    end
  end
end
