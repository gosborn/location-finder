class AddPointToVisits < ActiveRecord::Migration[6.0]
  def change
    add_column :visits, :latlng, :st_point, :geographic => true
  end
end
