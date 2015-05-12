class CreatePhotoAttachments < ActiveRecord::Migration
  def change
    create_table :photo_attachments do |t|
      t.references :photo,           null: false
      t.references :attachable,      null: false, polymorphic: true
      t.string     :attachable_name, null: false

      t.timestamps null: false

      t.index [:photo_id, :attachable_id, :attachable_type, :attachable_name],
              name: 'index_photo_attachments_on_attachable_fields',
              unique: true
    end

    add_foreign_key :photo_attachments, :photos, on_delete: :cascade
  end
end
