require "spec_helper"
require "generators/spree_easy_gift_cards/gift_card_product/gift_card_product_generator"

describe SpreeEasyGiftCards::Generators::GiftCardProductGenerator, type: :generator do
  destination File.expand_path("../../tmp", File.dirname(__FILE__))


  before(:all) do
    prepare_destination
    prepare_test_environment
    run_generator
  end

  it "creates a gift card product" do
    expect(gift_card_product).to_not be_nil
  end

  it "creates gift card variants" do
    expect(gift_card_product.variants.count).to eq(5)
  end

  it "creates a gift card association from product" do
    expect(gift_card_product.gift_card).to_not be_nil
  end

  private
    def prepare_test_environment
      FactoryGirl.create :shipping_category, name: 'Default'
    end

    def gift_card_product
      Spree::Product.find_by(slug: 'gift-card')
    end
end
