class CreateVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :visits, id: :uuid do |t|
      t.text :description
      t.decimal :latitude, :precision => 10, :scale => 6
      t.decimal :longitude, :precision => 10, :scale => 6
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.references :location, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
