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

  context :recipient_email do
    it "returns recipient_email if available" do
      expect(gift_card.recipient_email).to eq(gift_card.data[:recipient_email])
    end

    it "returns user email if recipient_email not available" do
      gift_card.data = {:recipient_email => nil}.merge(gift_card.data.except(:recipient_email))
      expect(gift_card.recipient_email).to eq(user.email)
    end
  end

  context :activate do
    it "generates and saves a random code and sends a gift card email" do
      gift_card.activate
      expect(gift_card.code).to_not be_nil
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  context :sanitize_data do
    it "calls before save" do
      expect(gift_card).to receive(:sanitize_data)
      gift_card.run_callbacks(:save)
    end

    it "removes tags" do
      good_data = gift_card.data
      with_tags = good_data.map{ |k,v| {k => "<p>#{v}</p>"} }.reduce(:merge)
      gift_card.data = with_tags
      gift_card.save
      expect(gift_card.data).to eq(good_data)
    end
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

  context :generate_code do
    it "returns a random code with length set on configuration" do
      code_length = 30
      SpreeEasyGiftCards.configuration do |config|
        config.code_length = code_length
      end
      code = gift_card.send(:generate_code)
      expect(code.size).to eq(code_length)
    end
  end
end
