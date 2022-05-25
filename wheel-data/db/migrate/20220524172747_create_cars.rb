class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.references :manufacturer, null: false, foreign_key: true
      t.integer :year
      t.string :name

      t.timestamps
    end
  end
end
