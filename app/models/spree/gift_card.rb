class Spree::GiftCard < ActiveRecord::Base
  belongs_to :line_item, class_name: 'Spree::LineItem'

  store :data

  def order
    line_item.order
  end

  def user
    order.user
  end
end
