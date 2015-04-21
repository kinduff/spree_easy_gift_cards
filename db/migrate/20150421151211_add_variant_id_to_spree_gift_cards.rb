class AddVariantIdToSpreeGiftCards < ActiveRecord::Migration
  def change
    add_column :spree_gift_cards, :variant_id, :integer
  end
end
