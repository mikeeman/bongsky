class AddLatAndLonAndAddressToUberlocation < ActiveRecord::Migration[5.0]
  def change
    add_column :uberlocations, :latitude, :float
    add_column :uberlocations, :longitude, :float
    add_column :uberlocations, :address, :string
  end
end
