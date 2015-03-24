require 'spec_helper'

RSpec.describe Spree::GiftCard, type: :model do
  let(:user) { create :user }
  let(:gift_card) { create :gift_card, user: user }
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

  context :add_default_data do
    it "adds data before create when empty data" do
      expect(gift_card).to receive(:add_default_data)
      expect(gift_card.data).to_not be_empty
      gift_card.run_callbacks(:create)
    end

    it "assigns custom data when create" do
      expect(gift_card_custom_data).to_not receive(:add_default_data)
      expect(gift_card_custom_data.data.deep_symbolize_keys.keys).to eq(custom_data.keys)
    end

    it "resets to default data if reset is true" do
      gift_card_custom_data.add_default_data(true)
      expect(gift_card_custom_data.data).to eq(gift_card.data)
    end
  end

  context :fix_data do
    it "fixes data before save" do
      expect(gift_card).to receive(:fix_data)
      expect(gift_card.data).to_not be_empty
      gift_card.run_callbacks(:save)
    end

    it "fixes data adding label and value to missing keys" do
      result = {:foo => {:label => 'Foo', :value => ''}}
      expect(gift_card_custom_data.data.deep_symbolize_keys).to eq(result)
    end

    it "leaves key as is if no missing keys" do
      expect(gift_card_good_custom_data.data.deep_symbolize_keys).to eq(good_custom_data)
    end
  end
end
