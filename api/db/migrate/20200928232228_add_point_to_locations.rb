class AddPointToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :latlng, :st_point, :geographic => true
  end
end
