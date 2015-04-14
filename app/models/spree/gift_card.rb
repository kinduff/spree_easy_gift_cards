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

  private
    def verify_data
      config_keys = SpreeEasyGiftCards.fields.keys
      errors.add(:data, "invalid") unless config_keys & config_keys == data.keys
    end

    def sanitize_data
      self.data = data.map{ |k,v| {k => v.gsub(/<[^>]*>/ui,'')} }.reduce(:merge)
    end
end
