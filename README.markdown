SimplestPhoto
=============

The easiest way to add photos to your Rails app and attach them to your models.

SimplestPhoto ...

* is dead simple to use
* is easy to change—migrations and models live in your app and you can do whatever you want to them
* caches your Dragonfly-processed images for you


How to use
----------

1. Add it to your `Gemfile` and `bundle install` that thing.
2. Generate the Dragonfly config:

        rails generate dragonfly

3. Generate the models and migrations:

        rails generate simplest_photo

4. Do some `rake db:migrate`
5. Configure your models:

        class Dinosaur < ActiveRecord::Base
          extend SimplestPhoto::HasPhoto

          has_photo :hero, required: true
          has_photo :centerfold
        end

6. Update your Dragonfly config to generate `PhotoCropping`s:

        # config/initializers/dragonfly.rb
        Dragonfly.app.configure do
          SimplestPhoto::UrlHelper.install(self)
        end


How it works
------------

### Models

SimplestPhoto contains three models:

1. `Photo`: the core photo model, where the Dragonfly attachment actually happens.
2. `PhotoAttachment`: the join table that connects a `Photo` with the things it is attached to.
3. `PhotoCropping`: model used to cache processed images.

`PhotoCropping` needs a bit of explanation. When you ask Dragonfly for an image at `400x400#`, it generates a unique job URL for that image. When that job URL is requested, Dragonfly does the processing, sends down the image, and then forgets about it. This is no good in production.

SimplestPhoto caches these processed photos by tapping into Dragonfly's URL method. When a new job comes in, SimplestPhoto checks for any `PhotoCropping`s with that job ID. If it finds one, it generates the URL to the stored image and sends that back. If it doesn't find one, it processes the image, stores it, inserts a new `PhotoCropping` record with that job ID, and sends down the processed image. The next time that job URL is generated, SimplestPhoto will use the stored image and skip the processing. Groovy.

### Attachments

Suppose you have this model:

    class Monster < ActiveRecord::Base
      extend SimplestPhoto::HasPhoto

      has_photo :headshot, required: true
    end

SimplestPhoto generates this:

    class Monster < ActiveRecord::Base
      extend SimplestPhoto::HasPhoto

      has_one :headshot_attachment,
              -> { where(attachable_name: :headshot) },
              as:         :attachable,
              class_name: 'PhotoAttachment',
              dependent:  :destroy

      has_one :headshot
              through: :headshot_attachment,
              source:  :photo

      validates :headshot, presence: true
    end

Standard stuff. It also defines `#headshot_id` and `#headshot_id=` accessors, which are what you should use in a form:

    f.input :headshot_id, collection: Photo.all

### Customizations

To customize the valid image file extensions (which defaults to allowing `.jpg`, `.jpeg`, or `.png` extensions), override the `valid_image_extensions` method in the generated `Photo` model:
```ruby
class Photo < ActiveRecord::Base
  def valid_image_extensions
    %w(jpg jpeg png gif)
  end
end
```
