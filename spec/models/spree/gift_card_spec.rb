require 'spec_helper'

RSpec.describe Spree::GiftCard, type: :model do
  let(:gift_card) { create :gift_card }

  it "belongs to a product" do
    expect(gift_card.product.present?).to be_truthy
  end
end
