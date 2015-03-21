class Spree::GiftCard < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'

  store :data

  before_create :add_default_data
  before_save :fix_data

  GIFT_CARD_DEFAULT_VALUES = {
    :name => {
      :label => 'Recipient\'s name',
      :value => ''
    },
    :email => {
      :label => 'Recipient\'s email',
      :value => ''
    },
    :message => {
      :label => 'Special gift message',
      :value => ''
    }
  }

  def add_default_data(reset=false)
    if reset or self.data.blank?
      self.data = GIFT_CARD_DEFAULT_VALUES
    end
  end

  def fix_data
    new_data = self.data.deep_symbolize_keys
    new_data.each do |key, value|
      if value.is_a? String or !(value.keys - [:label, :value]).blank?
        new_data[key] = {:label => key.to_s.titleize, :value => ''} 
      end
    end
    self.data = new_data
  end
end
