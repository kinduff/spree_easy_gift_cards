require 'spec_helper'
require 'generators/spree_easy_gift_cards/gift_card_product/gift_card_product_generator'

describe "Gift Card Code", type: :feature, inaccessible: true, js: true do
  let!(:country) { create(:country, name: "United States of America", states_required: true) }
  let!(:state) { create(:state, name: "Alabama", country: country) }
  let!(:zone) { create(:zone) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:payment_method) { create(:check_payment_method) }
  let!(:guest_product) { create(:product, name: "RoR Mug", price: 100) }
  
  let(:product) { Spree::Product.find_by(slug: 'gift-card') }
  let(:user) { create :user }
  let(:order) { create :order, user: user }
  let(:line_item) { create :line_item, order: order, variant: product.variants.first }
  let(:gift_card) { create :gift_card, line_item: line_item }

  before do
    SpreeEasyGiftCards::Generators::GiftCardProductGenerator.start
    gift_card.activate
  end

  context "visitor makes checkout as guest without registration" do
    before do
      visit spree.root_path
      click_link "RoR Mug"
      click_button "add-to-cart-button"
      click_button "Checkout"
      fill_in "order_email", with: "spree@example.com"
      click_button "Continue"
      fill_in "First Name", with: "John"
      fill_in "Last Name", with: "Smith"
      fill_in "Street Address", with: "1 John Street"
      fill_in "City", with: "City of John"
      fill_in "Zip", with: "01337"
      select country.name, from: "Country"
      select state.name, from: "order[bill_address_attributes][state_id]"
      fill_in "Phone", with: "555-555-5555"

      # To shipping method screen
      click_button "Save and Continue"
      # To payment screen
      click_button "Save and Continue"
    end

    context "with a promotion" do
      it "applies a promotion to an order" do
        fill_in "order_coupon_code", with: gift_card.code
        click_button "Save and Continue"
        expect(page).to have_content("Promotion (Gift Card)   -#{Spree::Money.new(gift_card.amount)}")
      end
    end
  end
end
