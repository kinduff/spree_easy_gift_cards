class AddLineItemIdToSpreeGiftCards < ActiveRecord::Migration
  def change
    add_column :spree_gift_cards, :line_item_id, :integer
  end
end
