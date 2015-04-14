require 'spec_helper'
require 'generators/spree_easy_gift_cards/gift_card_product/gift_card_product_generator'

describe "Cart", type: :feature, inaccessible: true do
  before do
    SpreeEasyGiftCards::Generators::GiftCardProductGenerator.start
  end

  context "disabled quantity input" do
    before(:each) do
      create(:product, name: "RoR Mug")
      visit spree.root_path
    end

    it "disables if gift card" do
      click_link "Gift Card"
      click_button "add-to-cart-button"
      expect(page).to have_css("#order_line_items_attributes_0_quantity[disabled]")
    end

    it "doesn't disables if not gift card" do
      click_link "RoR Mug"
      click_button "add-to-cart-button"
      expect(page).to_not have_css("#order_line_items_attributes_0_quantity[disabled]")
    end
  end
end
