class Upload < ApplicationRecord
	attribute :photos, ArrayType.new
	mount_uploaders :photos, PhotoUploader
	serialize :photos, JSON # For SQLite since it does not support JSON

	attribute :thumbnails, ArrayType.new
	mount_uploaders :thumbnails, ThumbnailUploader
	serialize :thumbnails, JSON # For SQLite since it does not support JSON
end
