module SimplestPhoto
  module Model
    module Attachment
      def attached_to(resource)
        belongs_to resource.to_sym

        belongs_to :attachable,
                   polymorphic: true,
                   touch:       true

        validates resource.to_sym, :attachable, presence: true

        validates :"#{resource}_id",
                  uniqueness: { scope: [:attachable_id, :attachable_type, :attachable_name] }

        class_eval do
          scope :by_attachable, -> {
            order(attachable_type: :asc,
                  attachable_id:   :asc,
                  attachable_name: :asc)
          }
        end
      end
    end
  end
end
