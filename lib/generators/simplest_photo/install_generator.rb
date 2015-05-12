require 'rails/generators/active_record/migration'

module SimplestPhoto
  class InstallGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    source_root File.expand_path("../templates", __FILE__)

    def install_models
      copy_file "models/photo.rb",            "app/models/photo.rb"
      copy_file "models/photo_attachment.rb", "app/models/photo_attachment.rb"
      copy_file "models/photo_cropping.rb",   "app/models/photo_cropping.rb"
    end

    def install_migrations
      migration_template 'migrations/create_photos.rb',            'db/migrate/create_photos.rb'
      migration_template 'migrations/create_photo_attachments.rb', 'db/migrate/create_photo_attachments.rb'
      migration_template 'migrations/create_photo_croppings.rb',   'db/migrate/create_photo_croppings.rb'
    end
  end
end
