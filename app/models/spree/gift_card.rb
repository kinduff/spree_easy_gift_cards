class Spree::GiftCard < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :user, class_name: Spree.user_class
  belongs_to :order, class_name: 'Spree::Order'
  belongs_to :line_item, class_name: 'Spree::LineItem'

  store :data
end
