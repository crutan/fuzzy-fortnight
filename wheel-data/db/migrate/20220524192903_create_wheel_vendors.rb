class CreateWheelVendors < ActiveRecord::Migration[7.0]
  def change
    create_table :wheel_vendors do |t|
      t.string :name

      t.timestamps
    end
  end
end
