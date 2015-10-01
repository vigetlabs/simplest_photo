module SimplestPhoto
  module HasPhoto

    def has_photo(name, required: false, on: nil)
      has_one :"#{name}_attachment",
              -> { where(attachable_name: name) },
              as:         :attachable,
              class_name: 'PhotoAttachment',
              dependent:  :destroy

      has_one name.to_sym,
              through: "#{name}_attachment",
              source:  :photo

      if required
        validates name, presence: true, on: on
      end

      foreign_key = "#{name}_id"

      # Save the associated target that was set in the [attr]_id= method
      # definition.
      after_save do
        if attribute_changed?(foreign_key)
          association(name).replace(association(name).target)
        end
      end


      define_method foreign_key do
        ivar = "@#{foreign_key}"

        return instance_variable_get(ivar) if instance_variable_defined?(ivar)

        instance_variable_set(ivar, self.send(name).try(:id))
      end

      define_method "#{foreign_key}=" do |new_id|
        ivar = "@#{foreign_key}"

        unless new_id.to_i == instance_variable_get(ivar)
          # For ActiveModel::Dirty
          attribute_will_change!(foreign_key)

          # Set the target of this association without saving to the database
          association(name).target = Photo.where(id: new_id).first

          instance_variable_set(ivar, new_id)
        end
      end

      define_method "#{name}?" do
        send(name).present?
      end
    end

  end
end
