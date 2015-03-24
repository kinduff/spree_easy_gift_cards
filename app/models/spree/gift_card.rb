class Spree::GiftCard < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :user, class_name: Spree.user_class

  store :data

  before_create :add_default_data
  before_save :fix_data

  GIFT_CARD_DEFAULT_VALUES = {
    :recipient_name => nil,
    :recipient_email => nil,
    :message => nil
  }

  def add_default_data(reset=false)
    if reset or self.data.blank?
      self.data = GIFT_CARD_DEFAULT_VALUES
    end
  end

  def fix_data
    new_data = self.data.deep_symbolize_keys
    new_data.each do |key, value|
      if value.is_a? String or value.nil? or !(value.keys - [:label, :value]).blank?
        new_data[key] = {:label => key.to_s.humanize, :value => ''}
      end
    end
    self.data = new_data
  end
end
