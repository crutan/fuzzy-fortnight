class CreateTrims < ActiveRecord::Migration[7.0]
  def change
    create_table :trims do |t|
      t.string :name
      t.references :car, null: false, foreign_key: true
      t.string :bolt_pattern
      t.integer :min_offset
      t.integer :max_offset
      t.integer :min_width
      t.integer :max_width
      t.integer :min_diameter
      t.integer :max_diameter

      t.timestamps
    end
  end
end
