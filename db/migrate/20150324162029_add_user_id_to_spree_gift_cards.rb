class AddUserIdToSpreeGiftCards < ActiveRecord::Migration
  def change
    add_column :spree_gift_cards, :user_id, :integer
  end
end
