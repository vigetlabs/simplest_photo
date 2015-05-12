module SimplestPhoto
  module Model
    module PhotoAttachment

      def self.extended(base)
        base.class_eval do
          belongs_to :photo

          belongs_to :attachable,
                     polymorphic: true,
                     touch:       true

          validates :photo, :attachable, presence: true

          validates :photo_id,
                    uniqueness: { scope: [:attachable_id, :attachable_type, :attachable_name] }

          scope :by_attachable, -> do
            order(attachable_type: :asc,
                  attachable_id:   :asc,
                  attachable_name: :asc)
          end
        end
      end

    end
  end
end
