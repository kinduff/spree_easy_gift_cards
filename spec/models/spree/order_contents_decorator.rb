require 'spec_helper'

RSpec.describe Spree::OrderContents, type: :model do
  let(:order) { Spree::Order.create }
  let(:product) { create(:product) }
  let(:variant) { create(:variant, product: product) }

  subject { described_class.new(order) }

  context "#add" do
    before do
      product.create_gift_card
    end

    it 'should add new line item if variant responds true to gift_card?' do
      subject.add(variant, 1)
      line_item = subject.add(variant, 1)
      expect(line_item.quantity).to eq(1)
      expect(order.line_items.size).to eq(2)
    end
  end
end
