require 'spec_helper'

describe Spree.user_class, :type => :model do
  let(:user) { create :user }
  let(:product) { create :product, slug: 'gift-card' }
  let(:variant) { create :variant, product: product }
  let!(:order) { create :order, user: user }
  let!(:line_item) { create :line_item, variant: variant, order: order }
  let!(:gift_card) { create :gift_card, line_item: line_item }

  it "has many gift cards" do
    expect(user.gift_cards).to eq([gift_card])
  end
end
