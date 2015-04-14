class AddCodeToSpreeGiftCards < ActiveRecord::Migration
  def change
    add_column :spree_gift_cards, :code, :string
  end
end
