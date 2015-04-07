class RemoveUserIdOrderIdFromSpreeGiftCards < ActiveRecord::Migration
  def change
    remove_column :spree_gift_cards, :product_id, :integer
    remove_column :spree_gift_cards, :user_id, :integer
    remove_column :spree_gift_cards, :order_id, :integer
  end
end
