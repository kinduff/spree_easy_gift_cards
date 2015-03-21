require 'spec_helper'

RSpec.describe Spree::Product, type: :model do
  let(:product) { create :product }

  it "can create a gift card" do
    expect(product.create_gift_card).to be_truthy
  end

  it "has a gift card" do
    product.create_gift_card
    expect(product.gift_card.present?).to be_truthy
  end

  context :gift_card? do
    it "returns true if gift card is present" do
      product.create_gift_card
      expect(product.gift_card?).to be_truthy
    end
  end
end
