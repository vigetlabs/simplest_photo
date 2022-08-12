require 'active_model/validator'

module SimplestPhoto
  module Model
    module Validations
      class AttachmentPropertyValidator < ::Dragonfly::Model::Validations::PropertyValidator
        include ActiveModel::Validations::Clusivity

        def validate_each(model, attribute, attachment)
          if attachment
            unless include?(model, attachment.send(property_name))
              model.errors.add(attribute, message(property, model))
            end
          end
        rescue RuntimeError => e
          ::Dragonfly.warn("validation of property #{property_name} of #{attribute} failed with error #{e}")
          model.errors.add(attribute, message(nil, model))
        end

        private

        def delimiter
          @delimiter ||= options[:in] || options[:within] || options[:as]
        end
      end

      private

      def validates_attachment_property(property_name, options)
        raise ArgumentError, "you need to provide the attribute which has the property, using :of => <attribute_name>" unless options[:of]

        validates_with(
          SimplestPhoto::Model::Validations::AttachmentPropertyValidator,
          options.merge(
            attributes:    [*options[:of]],
            property_name: property_name
          )
        )
      end
    end
  end
end

