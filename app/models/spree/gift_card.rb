class Spree::GiftCard < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'

  store :data

  before_create :add_default_data

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

  def add_default_data
    if self.data.blank?
      self.data = GIFT_CARD_DEFAULT_VALUES
    end
  end
end
