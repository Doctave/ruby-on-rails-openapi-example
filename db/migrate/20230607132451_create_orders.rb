class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :kind, null: false
      t.decimal :price, null: false
      t.string :customer, null: false

      t.timestamps
    end
  end
end
