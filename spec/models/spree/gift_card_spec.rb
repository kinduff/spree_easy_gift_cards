require 'spec_helper'

RSpec.describe Spree::GiftCard, type: :model do
  let(:gift_card) { create :gift_card }
  let(:custom_data) { {:custom => 'data'} }
  let(:gift_card_custom_data) { create :gift_card, data: custom_data }

  it "belongs to a product" do
    expect(gift_card.product.present?).to be_truthy
  end

  it "adds data before create when empty data" do
    expect(gift_card).to receive(:add_default_data)
    expect(gift_card.data).to_not be_empty
    gift_card.run_callbacks(:create)
  end

  it "assigns custom data when create" do
    expect(gift_card_custom_data).to_not receive(:add_default_data)
    expect(gift_card_custom_data.data.deep_symbolize_keys).to eq(custom_data)
  end
end
