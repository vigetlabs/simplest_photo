module SimplestPhoto
  module HasPhoto
   def self.extended(base)
      base.extend Model::HasAttachment
    end

    def has_photo(name, options = {})
      has_attachment name, options.merge(class_name: 'Photo')
    end
  end
end
