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

  context :valid do
    it "match the same keys as gem fields keys" do
      valid_keys = Hash[SpreeEasyGiftCards.fields.keys.map {|v| [v,v.upcase]}]
      gift_card.data = valid_keys
      expect(gift_card).to be_valid
    end
  end

  context :invalid do
    it "doesn't match the same keys as gem fields keys" do
      invalid_keys = {:invalid_keys => true}
      gift_card.data = invalid_keys
      expect(gift_card).to be_invalid
    end
  end
end
