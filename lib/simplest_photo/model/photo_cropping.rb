module SimplestPhoto
  module Model
    module PhotoCropping

      def self.extended(base)
        base.class_eval do
          belongs_to :photo, touch: true

          before_destroy :delete_file


          private

          def delete_file
            Dragonfly.app.datastore.destroy(uid)
          end
        end
      end

    end
  end
end
