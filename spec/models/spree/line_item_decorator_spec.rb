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
      it "builds a gift card" do
        line_item.options = {"gift_card" => {"recipient_name"=>"Alejandro AR", "recipient_email"=>"abarcadabra@gmail.com", "message"=>"Lorem Ipsum Dolor sit amet"}}
        expect(line_item.gift_card).to_not be_nil
      end
    end
  end
end
