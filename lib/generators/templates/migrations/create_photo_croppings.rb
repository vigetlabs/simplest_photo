<%
  parent_class = ActiveRecord::Migration
  parent_class = parent_class[parent_class.current_version] if Rails::VERSION::MAJOR >= 5
-%>

class CreatePhotoCroppings < <%= parent_class.to_s %>
  def change
    create_table :photo_croppings do |t|
      t.references :photo,     null: false
      t.string     :signature, null: false
      t.string     :uid,       null: false

      <%- if Rails::VERSION::MAJOR >= 5 -%>
      t.timestamps
      <%- else -%>
      t.timestamps null: false
      <%- end -%>

      t.index :signature, unique: true
    end

    add_foreign_key :photo_croppings, :photos, on_delete: :cascade
  end
end
