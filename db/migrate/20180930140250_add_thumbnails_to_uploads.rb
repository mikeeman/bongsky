class AddThumbnailsToUploads < ActiveRecord::Migration[5.0]
  def change
    add_column :uploads, :thumbnails, :string
  end
end
