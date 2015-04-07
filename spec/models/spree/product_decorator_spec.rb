require 'spec_helper'

RSpec.describe Spree::Product, type: :model do
  let(:product) { create :product, slug: 'gift-card' }

  context :gift_card? do
    it "returns true if slug matches configuration" do
      expect(product.gift_card?).to be_truthy
    end
  end
end
