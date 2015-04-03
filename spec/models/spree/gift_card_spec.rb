require 'spec_helper'

RSpec.describe Spree::GiftCard, type: :model do
  let(:user) { create :user }
  let(:order) { create :order }
  let(:line_item) { create :line_item, order: order}
  let(:gift_card) { create :gift_card, user: user, order: order, line_item: line_item }
  let(:custom_data) { {:foo => 'bar'} }
  let(:good_custom_data) { {:foo => {:label => 'Foo', :value => 'Bar'} } }
  let(:gift_card_custom_data) { create :gift_card, data: custom_data }
  let(:gift_card_good_custom_data) { create :gift_card, data: good_custom_data }

  it "belongs to a product" do
    expect(gift_card.product.present?).to be_truthy
  end

  it "belongs to a user" do
    expect(gift_card.user).to eq(user)
  end

  it "belongs to an order" do
    expect(gift_card.order).to eq(order)
  end

  it "belongs to a line_item" do
    expect(gift_card.line_item).to eq(line_item)
  end
end
