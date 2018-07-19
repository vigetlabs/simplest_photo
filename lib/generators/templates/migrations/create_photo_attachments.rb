<%
  parent_class = ActiveRecord::Migration
  parent_class = parent_class[parent_class.current_version] if Rails::VERSION::MAJOR >= 5
-%>

class CreatePhotoAttachments < <%= parent_class.to_s %>
  def change
    create_table :photo_attachments do |t|
      t.references :photo,           null: false
      t.references :attachable,      null: false, polymorphic: true
      t.string     :attachable_name, null: false

      <%- if Rails::VERSION::MAJOR >= 5 -%>
      t.timestamps
      <%- else -%>
      t.timestamps null: false
      <%- end -%>

      t.index [:photo_id, :attachable_id, :attachable_type, :attachable_name],
              name: 'index_photo_attachments_on_attachable_fields',
              unique: true
    end

    add_foreign_key :photo_attachments, :photos, on_delete: :cascade
  end
end
