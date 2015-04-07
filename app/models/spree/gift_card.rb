class Spree::GiftCard < ActiveRecord::Base
  belongs_to :line_item, class_name: 'Spree::LineItem'

  store :data

  validate :verify_data

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
end
