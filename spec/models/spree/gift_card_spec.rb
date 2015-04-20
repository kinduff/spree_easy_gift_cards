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

  it "returns false if not redeemed" do
    expect(gift_card.redeemed?).to be_falsy
  end

  it "returns false if not activated" do
    expect(gift_card.activated?).to be_falsy
  end

  it "returns true if activated" do
    gift_card.activate
    expect(gift_card.activated?).to be_truthy
  end

  context :redeemed? do
    let!(:adjustment) { Spree::Adjustment.create!(label: 'Promotion (Gift Card)', amount: (gift_card.amount*-1), order: order, adjustable: order, source_type: "Spree::PromotionAction", adjustable_type: "Spree::Order") }
    before do
      gift_card.activate
      order.adjustments << adjustment
      order.promotions << gift_card.promotion
    end

    it "returns true if redeemed" do
      expect(gift_card.redeemed?).to be_truthy
    end

    it "returns the order that redeemed" do
      expect(gift_card.order).to eq(order)
    end

    it "returns the user that redeemed" do
      expect(gift_card.redeemed_by_user).to eq(user)
    end

    it "returns a promotion" do
      expect(gift_card.promotion).to_not be_nil
    end
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

  it "returns the amount" do
    expect(gift_card.amount).to eq(line_item.price)
  end

  context :activate do
    before(:each) do
      gift_card.activate
    end

    it "generates and saves a random code" do
      expect(gift_card.code).to_not be_nil
    end

    it "sends a gift card email" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "generates a promotion" do
      expect(Spree::Promotion.all.count).to eq(1)
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

  context :generate_promotion do
    it "generates a valid promotion" do
      promotion = gift_card.send(:generate_promotion)
      calculator = promotion.promotion_actions.first.calculator
      expect(promotion.name).to eq('Gift Card')
      expect(promotion.actions.count).to eq(1)
      expect(promotion.promotion_actions.count).to eq(1)
      expect(calculator.type).to eq("Spree::Calculator::FlatRate")
      expect(calculator.preferences[:amount]).to eq(gift_card.amount)
    end
  end
end
