class CreateSpreeGiftCards < ActiveRecord::Migration
  def change
    create_table :spree_gift_cards do |t|
      t.integer :product_id
      t.text :data

      t.timestamps null: false
    end
  end
end
