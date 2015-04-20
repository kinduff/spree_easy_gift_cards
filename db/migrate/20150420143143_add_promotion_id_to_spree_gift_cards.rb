class AddPromotionIdToSpreeGiftCards < ActiveRecord::Migration
  def change
    add_column :spree_gift_cards, :promotion_id, :integer
  end
end
