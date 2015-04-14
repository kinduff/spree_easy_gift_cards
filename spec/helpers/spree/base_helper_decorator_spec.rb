require 'spec_helper'

module Spree
  describe BaseHelper, :type => :helper do
    include BaseHelper
    let(:order) { create :order }
    let(:product) { create :product, slug: 'gift-card' }
    let(:variant) { create :variant, product: product }
    let(:line_item) { create :line_item, variant: variant, order: order }
    let(:gift_card) { create :gift_card, line_item: line_item }

    context "#gift_card_description_text" do
      before { line_item.options =  { gift_card: gift_card.data } }
      subject { gift_card_description_text(line_item) }

      it "should return a list of keys and values" do
        is_expected.to eq('<p><b>Recipient name:</b> Quentin Tarantino</p><p><b>Recipient email:</b> kill@bill.com</p><p><b>Message:</b> The less a man makes declarative statements, the less apt he is to look foolish in retrospect.</p>')
      end
    end
  end
end
