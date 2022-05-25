class CreateWheels < ActiveRecord::Migration[7.0]
  def change
    create_table :wheels do |t|
      t.string :bolt_pattern
      t.integer :offset
      t.integer :width
      t.integer :diameter
      t.string :vendor_sku
      t.string :vendor_id
      t.references :wheel_vendor, null: false, foreign_key: true
      t.string :finish
      t.string :brand
      t.timestamps
    end

    add_index(:wheels, [:bolt_pattern, :offset, :width, :diameter])
  end
end
