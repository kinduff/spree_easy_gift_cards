require 'spec_helper'

RSpec.describe Spree::OrderContents, type: :model do
  let(:order) { Spree::Order.create }
  let(:product) { create(:product, slug: 'gift-card') }
  let(:variant) { create(:variant, product: product) }
  let(:regular_product) { create(:product) }
  let(:regular_variant) { create(:variant, product: regular_product) }

  subject { described_class.new(order) }

  context "#add" do
    it 'should add new line item if variant responds true to gift_card?' do
      subject.add(variant, 1)
      line_item = subject.add(variant, 1)
      expect(line_item.quantity).to eq(1)
      expect(order.line_items.size).to eq(2)
    end

    it 'should update same line item if variant responds false to gift_card?' do
      subject.add(regular_variant, 1)
      line_item = subject.add(regular_variant, 1)
      expect(line_item.quantity).to eq(2)
      expect(order.line_items.size).to eq(1)
    end
  end
end
