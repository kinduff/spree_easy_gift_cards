require 'spec_helper'
require 'generators/spree_easy_gift_cards/gift_card_product/gift_card_product_generator'

describe "Visiting Products", type: :feature, inaccessible: true do
  let(:product) { Spree::Product.find_by(slug: 'gift-card') }

  before do
    SpreeEasyGiftCards::Generators::GiftCardProductGenerator.start
  end

  before(:each) do
    visit spree.root_path
  end

  context "a gift card product" do
    it "should be displayed" do
      expect { click_link product.name }.to_not raise_error
    end
    it "displays a gift card form" do
      click_link product.name
      SpreeEasyGiftCards.fields.each do |field, attributes|
        expect(page).to have_selector("#{attributes[:tag]}[name='options[gift_card][#{field.to_s}]']")
      end
      expect(page).to have_select('variant_id')
      expect(page).to have_content('Add To Cart')
    end
  end
end
