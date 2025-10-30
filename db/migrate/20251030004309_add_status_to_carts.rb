class AddStatusToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :status, :integer, default: 0, null: false
    add_index :carts, :status
  end
end
