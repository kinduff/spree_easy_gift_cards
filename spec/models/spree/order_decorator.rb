require 'spec_helper'

RSpec.describe Spree::Order, type: :model do
  let(:order) { create :order }
  let(:gift_card) { create :gift_card, order: order }

  it "has many gift cards" do
    expect(order.gift_cards).to eq([gift_card])
  end
end
