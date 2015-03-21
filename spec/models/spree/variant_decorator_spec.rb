require 'spec_helper'

RSpec.describe Spree::Variant, type: :model do
  let(:product) { create :product }
  let(:variant) { create :variant, product: product }
  before(:each) do
    product.create_gift_card
  end

  context :gift_card? do
    it "returns true if is a gift card" do
      expect(variant.gift_card?).to be_truthy
    end
  end
end
