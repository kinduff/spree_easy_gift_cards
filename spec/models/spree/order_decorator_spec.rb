require 'spec_helper'

RSpec.describe Spree::Order, type: :model do
  let(:product) { create :product, slug: 'gift-card' }
  let(:variant) { create :variant, product: product }
  let!(:order) { create :order }
  let!(:line_item) { create :line_item, variant: variant, order: order }
  let!(:gift_card) { create :gift_card, line_item: line_item }

  it "has many gift cards" do
    expect(order.gift_cards).to eq([gift_card])
  end
end
