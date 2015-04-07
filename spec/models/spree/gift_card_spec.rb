require 'spec_helper'

RSpec.describe Spree::GiftCard, type: :model do
  let(:user) { create :user }
  let(:order) { create :order, user: user }
  let(:product) { create :product, slug: 'gift-card' }
  let(:variant) { create :variant, product: product }
  let(:line_item) { create :line_item, order: order, variant: variant }
  let(:gift_card) { create :gift_card, line_item: line_item }

  it "belongs to a line_item" do
    expect(gift_card.line_item).to eq(line_item)
  end

  it "returns an order" do
    expect(gift_card.order).to eq(order)
  end

  it "returns a user" do
    expect(gift_card.user).to eq(user)
  end
end
