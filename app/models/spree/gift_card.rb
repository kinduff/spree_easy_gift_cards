class Spree::GiftCard < ActiveRecord::Base
  belongs_to :line_item, class_name: 'Spree::LineItem'

  store :data

  validate :verify_data

  before_save :sanitize_data

  def order
    line_item.order
  end

  def user
    order.user
  end

  def data
    self[:data].try :symbolize_keys
  end

  def recipient_email
    data[:recipient_email] || user.email
  end

  def activate
    self.update_attribute(:code, generate_code)
    Spree::GiftCardMailer.gift_card_email(self).deliver_now
  end

  def amount
    self.line_item.price
  end

  private
    def verify_data
      config_keys = SpreeEasyGiftCards.fields.keys
      errors.add(:data, "invalid") unless config_keys & config_keys == data.keys
    end

    def sanitize_data
      self.data = data.map{ |k,v| {k => v.gsub(/<[^>]*>/ui,'')} }.reduce(:merge)
    end

    def generate_code
      length = SpreeEasyGiftCards.code_length-1 # minus one because programming
      return loop do
        code = encrypted_code[0..length]
        break code unless Spree::Promotion.exists?(code: code)
      end
    end

    def encrypted_code
      Digest::SHA2.hexdigest([Time.now, rand].join)
    end
end
