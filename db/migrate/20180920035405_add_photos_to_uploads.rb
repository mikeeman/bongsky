class AddPhotosToUploads < ActiveRecord::Migration[5.0]
  def change
    add_column :uploads, :photos, :string
  end
end
