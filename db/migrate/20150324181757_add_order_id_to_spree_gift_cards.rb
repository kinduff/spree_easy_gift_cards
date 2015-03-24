class AddOrderIdToSpreeGiftCards < ActiveRecord::Migration
  def change
    add_column :spree_gift_cards, :order_id, :integer
  end
end
