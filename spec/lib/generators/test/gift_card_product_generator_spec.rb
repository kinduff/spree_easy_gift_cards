require "spec_helper"
require "generators/spree_easy_gift_cards/gift_card_product/gift_card_product_generator"

describe SpreeEasyGiftCards::Generators::GiftCardProductGenerator, type: :generator do
  destination File.expand_path("../../tmp", File.dirname(__FILE__))


  before(:all) do
    prepare_destination
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

  it "creates a 'Not Shippable' shipping category" do
    expect(shipping_category).to_not be_nil
  end

  it "associates 'Not Shippable' to gift card product" do
    expect(gift_card_product.shipping_category).to eq(shipping_category)
  end

  it "creates a 'Digital' shipping method" do
    expect(shipping_method).to_not be_nil
  end

  it "associates 'Digital' shipping method to 'Not Shippable' category" do
    expect(shipping_category.shipping_methods.find(shipping_method.id)).to eq(shipping_method)
  end

  private
    def gift_card_product
      Spree::Product.find_by(slug: 'gift-card')
    end

    def shipping_category
      Spree::ShippingCategory.find_by(name: 'Not Shippable')
    end

    def shipping_method
      Spree::ShippingMethod.find_by(name: 'Digital')
    end
end
