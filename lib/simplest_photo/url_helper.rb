module SimplestPhoto
  module UrlHelper
    def self.install(config)
      config.define_url do |app, job, opts|
        cropping = PhotoCropping.find_by(signature: job.signature)

        if job.process_steps.empty?
          # No processing to perform, link to the original
          app.datastore.url_for(job.uid)

        elsif cropping
          # A cropping already exists, link to it
          app.datastore.url_for(cropping.uid)

        else
          # Link to the job
          app.server.url_for(job)
        end
      end

      config.before_serve do |job, env|
        existing = PhotoCropping.find_by(signature: job.signature)

        if existing
          throw :halt, [301, {"Location" => job.app.remote_url_for(existing.uid)}, [""]]
        else
          photo = Photo.with_image_uid!(job.uid)
          uid = job.store

          begin
            PhotoCropping.create!(photo: photo, uid: uid, signature: job.signature)
          rescue ActiveRecord::RecordNotUnique
            existing = PhotoCropping.find_by(signature: job.signature)
            throw :halt, [301, {"Location" => job.app.remote_url_for(existing.uid)}, [""]]
          end
        end
      end
    end
  end
end
