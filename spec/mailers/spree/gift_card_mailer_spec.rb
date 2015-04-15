require 'spec_helper'

RSpec.describe Spree::GiftCardMailer do
  describe 'gift_card_email' do
    let(:user) { create :user }
    let(:order) { create :order, user: user }
    let(:product) { create :product, slug: 'gift-card' }
    let(:variant) { create :variant, product: product }
    let(:line_item) { create :line_item, order: order, variant: variant }
    let(:gift_card) { create :gift_card, line_item: line_item }
    let(:mail) { Spree::GiftCardMailer.gift_card_email(gift_card) }

    it 'renders the subject' do
      expect(mail.subject).to eq("#{Spree::Store.current.name} #{Spree.t('gift_card_mailer.gift_card_email.subject')}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([gift_card.recipient_email])
    end

    it 'assigns @gift_card' do
      expect(mail.body.encoded).to match(gift_card.id.to_s)
    end
  end
end
