class Upload < ApplicationRecord
	mount_uploaders :photos, PhotoUploader
	serialize :photos, JSON # For SQLite since it does not support JSON
end
