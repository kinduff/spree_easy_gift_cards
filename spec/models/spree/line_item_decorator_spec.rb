require 'spec_helper'

RSpec.describe Spree::LineItem, type: :model do
  let(:order) { create :order }
  let(:product) { create :product }
  let(:variant) { create :variant, product: product }
  let(:line_item) { create :line_item, variant: variant, order: order }
  before(:each) do
    product.create_gift_card
  end

  context :gift_card? do
    it "returns true if is a gift card" do
      expect(line_item.gift_card?).to be_truthy
    end
  end
end
