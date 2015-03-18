class Spree::GiftCard < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'

  store :data
end
