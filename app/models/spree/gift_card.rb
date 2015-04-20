class Spree::GiftCard < ActiveRecord::Base
  belongs_to :line_item, class_name: 'Spree::LineItem'
  belongs_to :promotion, class_name: 'Spree::Promotion'

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
    generate_promotion
    Spree::GiftCardMailer.gift_card_email(self).deliver_now
  end

  def amount
    self.line_item.price
  end

  def redeemed?
    !Spree::Promotion.find_by(code: code).nil?
  end

  def redeemed_by_order
    promotion.try(:orders).try(:first)
  end

  def redeemed_by_user
    order = redeemed_by_order
    (order.try(:user) || order.try(:email)) || nil
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

    def generate_promotion
      promo = self.create_promotion(
        name: "Gift Card",
        description: "$#{self.amount} Gift Card to: #{self.recipient_email} - Automatically Generated",
        match_policy: 'all',
        usage_limit: 1,
        code: self.code
      )
      promo.promotion_actions <<
        Spree::Promotion::Actions::CreateAdjustment.create(
          calculator: Spree::Calculator::FlatRate.new(preferred_amount: self.amount)
        )
      self.save!
      return promo
    end
end
