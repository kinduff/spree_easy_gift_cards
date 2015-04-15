module Spree
  class GiftCardMailer < BaseMailer
    def gift_card_email(gift_card, resend = false)
      @gift_card = gift_card
      @order = @gift_card.order
      subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
      subject += "#{Spree::Store.current.name} #{Spree.t('gift_card_mailer.gift_card_email.subject')}"
      mail(to: @gift_card.recipient_email, from: from_address, subject: subject)
    end
  end
end
