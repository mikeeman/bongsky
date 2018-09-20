class Upload < ApplicationRecord
	attribute :photos, ArrayType.new
	mount_uploaders :photos, PhotoUploader
	#serialize :photos, JSON # For SQLite since it does not support JSON
end
