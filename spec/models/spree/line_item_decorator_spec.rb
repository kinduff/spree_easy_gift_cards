require 'spec_helper'

RSpec.describe Spree::LineItem, type: :model do
  let(:order) { create :order }
  let(:product) { create :product, slug: 'gift-card' }
  let(:variant) { create :variant, product: product }
  let(:line_item) { create :line_item, variant: variant, order: order }

  it "has one gift card" do
    line_item.create_gift_card
    expect(line_item.gift_card).to_not be_nil
  end

  context :gift_card? do
    it "returns true if is a gift card" do
      expect(line_item.gift_card?).to be_truthy
    end
    context "#options=" do
      it "is valid if gift card fields match" do
        line_item.options = {"gift_card" => {"recipient_name"=>"Alejandro AR", "recipient_email"=>"abarcadabra@gmail.com", "message"=>"Lorem Ipsum Dolor sit amet"}}
        expect(line_item.gift_card).to_not be_nil
        expect(line_item).to be_valid
      end

      it "is not valid if gift card fields do not match" do
        line_item.options = {"gift_card" => {"invalid_field" => false} }
        expect(line_item).to be_invalid
      end

      it "can handle updating a line item with no currency" do
        allow(line_item.order).to receive(:currency) { nil }
        line_item.options = { currency: nil }
      end
    end
  end
end
