class CreatePhotoCroppings < ActiveRecord::Migration::Current
  def change
    create_table :photo_croppings do |t|
      t.references :photo,     null: false
      t.string     :signature, null: false
      t.string     :uid,       null: false

      t.timestamps null: false

      t.index :signature, unique: true
    end

    add_foreign_key :photo_croppings, :photos, on_delete: :cascade
  end
end
