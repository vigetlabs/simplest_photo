module SimplestPhoto
  module Model
    module Photo
      def self.extended(base)
        base.class_eval do
          extend SimplestPhoto::Model::Validations

          dragonfly_accessor :image

          has_many :photo_attachments, dependent: :destroy
          has_many :photo_croppings,   dependent: :destroy

          validates :name, :image, presence: true

          validates_attachment_property :format,
            of: :image,
            in: :valid_image_extensions,
            if: :image_changed?

          scope :by_name, -> { order(name: :asc) }

          delegate :url, :thumb, to: :image

          def valid_image_extensions
            %w(jpeg jpg png)
          end
        end
      end

      def with_image_uid!(uid)
        find_by!(image_uid: uid)
      end
    end
  end
end
