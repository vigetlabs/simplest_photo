module SimplestPhoto
  module Model
    module PhotoAttachment
      def self.extended(base)
        base.extend Attachment

        base.attached_to :photo
      end
    end
  end
end
