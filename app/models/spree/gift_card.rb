class Spree::GiftCard < ActiveRecord::Base
  belongs_to :variant, class_name: 'Spree::Variant'
  belongs_to :line_item, class_name: 'Spree::LineItem'
  belongs_to :promotion, class_name: 'Spree::Promotion'

  store :data

  validate :verify_data

  before_save :sanitize_data
  before_save :update_promotion_if_code_is_changed

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

  def activated?
    !(self.promotion.nil? && self.code.nil?)
  end

  def amount
    self.line_item.price
  end

  def redeemed?
    promotion ? (promotion.credits_count >= promotion.usage_limit) : false
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
      self.promotion = build_promotion(
        name: "Gift Card",
        description: "$#{self.amount} Gift Card to: #{self.recipient_email} - Automatically Generated",
        match_policy: 'all',
        usage_limit: 1,
        code: self.code
      )
      self.promotion.promotion_actions <<
        Spree::Promotion::Actions::CreateAdjustment.create(
          calculator: Spree::Calculator::FlatRate.new(preferred_amount: self.amount)
        )
      self.save!
      return self.promotion
    end

    def update_promotion_if_code_is_changed
      if self.code_changed? and self.promotion and !self.promotion.new_record?
        self.promotion.update_attribute(:code, self.code)
      end
    end
end
