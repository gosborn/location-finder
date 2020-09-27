class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations, id: :uuid do |t|
      t.string :name
      t.text :description
      t.decimal :latitude, :precision => 10, :scale => 6
      t.decimal :longitude, :precision => 10, :scale => 6

      t.timestamps
    end
    add_index :locations, :name, unique: true
  end
end
