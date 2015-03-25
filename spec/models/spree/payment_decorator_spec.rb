require 'spec_helper'

describe Spree::Payment, :type => :model do
  let(:order) { Spree::Order.create }

  let(:shipping_method) { create(:shipping_method, name: 'Digital', admin_name: 'Digital') }

  let(:shipment) do
     shipment = Spree::Shipment.create(cost: 1, state: 'ready')
     shipment.shipping_methods = [shipping_method]
     shipment.save
     shipment
   end

  let(:gateway) do
    gateway = Spree::Gateway::Bogus.new(:active => true)
    allow(gateway).to receive_messages :source_required => true
    gateway
  end

  let(:avs_code) { 'D' }
  let(:cvv_code) { 'M' }

  let(:card) { create :credit_card }

  let(:payment) do
    payment = Spree::Payment.new
    payment.source = card
    payment.order = order
    payment.payment_method = gateway
    payment.amount = 5
    payment.save
    payment
  end

  let!(:success_response) do
    ActiveMerchant::Billing::Response.new(true, '', {}, {
      authorization: '123',
      cvv_result: cvv_code,
      avs_result: { code: avs_code }
    })
  end

  describe "#capture!" do
    context "when payment is pending" do
      before do
        payment.amount = 100
        payment.state = 'pending'
        payment.response_code = '12345'
      end
      context "if successful" do
        context 'for entire amount' do
          before do
            expect(payment.payment_method).to receive(:capture).with(payment.display_amount.money.cents, payment.response_code, anything).and_return(success_response)
            SpreeEasyGiftCards.configuration do |config|
              config.auto_ship_digital_shipments = true
            end
          end

          it "should call ship_digital_shipments" do
            expect(payment).to receive(:ship_digital_shipments)
            payment.capture!
          end

          it "should ship digital shipments" do
            payment.order.shipments << shipment
            payment.capture!
            expect(payment.order.shipments.digitals.first.shipped?).to be_truthy
          end
          it "should not ship digital shipments if config.auto_ship_digital_shipments is false" do
            SpreeEasyGiftCards.configuration do |config|
              config.auto_ship_digital_shipments = false
            end
            payment.order.shipments << shipment
            payment.capture!
            expect(payment.order.shipments.digitals.first.shipped?).to be_falsy
          end
        end
      end
    end
  end
end
