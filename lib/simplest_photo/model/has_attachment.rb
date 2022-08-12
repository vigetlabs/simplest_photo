module SimplestPhoto
  module Model
    module HasAttachment
      def has_attachment(name, class_name:, required: false, on: %i(create update), includes: nil)
        klass = class_name.to_s.constantize

        has_one :"#{name}_attachment",
          -> { where attachable_name: name },
          as:         :attachable,
          class_name: "#{class_name}Attachment",
          dependent:  :destroy

        has_one name.to_sym,
          -> { includes(includes) },
          through: "#{name}_attachment",
          source:  klass.model_name.singular.to_sym

        if required
          validates name, presence: true, on: on
        end

        foreign_key = "#{name}_id"

        # Save the associated target that was set in the [attr]_id= method
        # definition.
        after_save do
          if saved_change_to_attribute?(foreign_key)
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

            # In accepts_nested_attributes_for scenarios, the nested model
            # doesn't save if the photo ID is the only thing that's changed.
            # So, we force a save by updating the timetamp.
            if attribute_names.include?("updated_at")
              self.updated_at = current_time_from_proper_timezone
            end

            # Set the target of this association without saving to the database
            association(name).target = klass.where(id: new_id).first

            instance_variable_set(ivar, new_id)
          end
        end

        define_method "#{name}?" do
          send(name).present?
        end
      end
    end
  end
end
