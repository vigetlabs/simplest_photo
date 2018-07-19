<%
  parent_class = ActiveRecord::Migration
  parent_class = parent_class[parent_class.current_version] if Rails::VERSION::MAJOR >= 5
-%>

class CreatePhotos < <%= parent_class.to_s %>
  def change
    create_table :photos do |t|
      t.string :name,       null: false
      t.string :image_uid,  null: false
      t.string :image_name

      <%- if Rails::VERSION::MAJOR >= 5 -%>
      t.timestamps
      <%- else -%>
      t.timestamps null: false
      <%- end -%>
    end
  end
end
