# Administrate::SerializedFields

[![Build Status: master](https://travis-ci.com/XPBytes/administrate-serialized_fields.svg)](https://travis-ci.com/XPBytes/administrate-serialized_fields)
[![Gem Version](https://badge.fury.io/rb/administrate-serialized_fields.svg)](https://badge.fury.io/rb/administrate-serialized_fields)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

Automatically deserialize administrate fields on form submit.
 
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'administrate-serialized_fields'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install administrate-serialized_fields

## Usage

In order to use this, `include 'Administrate::SerializedFields'` in your base admin `ApplicationController`.

```ruby
require 'administrate/serialized_fields'

class ApplicationController < Administrate::ApplicationController
  include Administrate::SerializedFields
end

class NotificationController < ApplicationController
  deserialize_json_fields :options, :messages, :settings
end
```

The `deserialize_json_fields` by default looks for `Oj` and falls back to `JSON`. Use `load:` or `deserialize_fields` to
apply custom behaviour or a different deserializer.

You _must_ ensure there is a method `read_param` that takes **2** arguments (key and value), as opposed to the 0.11.0
administrate one param (value). Alternatively, use the [`administrate-base_controller` gem](https://github.com/XPBytes/administrate-base_controller)
and get this addition for free.

```ruby
class Application < Administrate::ApplicationController
  protected
  
  def resource_params
    permitted = params.require(resource_class.model_name.param_key)
                      .permit(dashboard.permitted_attributes)
                      .to_h

    permitted.each_with_object(permitted) do |(k, v), result|
      result[k] = read_param(k, v)
    end
  end
  
  def read_param(_, data)
    if data.is_a?(ActionController::Parameters) && data[:type]
      return read_param_value(data)
    end

    data
  end
end
```

## Related

- [`Administrate`](https://github.com/thoughtbot/administrate): A Rails engine that helps you put together a super-flexible admin dashboard.
- [`Administrate::BaseController`](https://github.com/XPBytes/administrate-base_controller): :stars: A set of application controller improvements.

### Concerns

- [`Administrate::DefaultOrder`](https://github.com/XPBytes/administrate-default_order): :1234: Sets the default order for a resource in a administrate controller.

### Fields

- [`Administrate::Field::Code`](https://github.com/XPBytes/administrate-field-code): :pencil: A `text` field that shows code.
- [`Administrate::Field::Hyperlink`](https://github.com/XPBytes/administrate-field-hyperlink): :pencil: A `string` field that is shows a hyperlink.
- [`Adminisrtate::Field::JsonEditor`](https://github.com/XPBytes/administrate-field-json_editor): :pencil: A `text` field that shows a [JSON editor](https://github.com/josdejong/jsoneditor).
- [`Administrate::Field::ScopedBelongsTo`](https://github.com/XPBytes/administrate-field-scoped_belongs_to): :pencil: A `belongs_to` field that yields itself to the scope `lambda`.
- [`Administrate::Field::ScopedHasMany`](https://github.com/XPBytes/administrate-field-scoped_has_many): :pencil: A `has_many` field that yields itself to the scope `lambda`.
- [`Administrate::Field::TimeAgo`](https://github.com/XPBytes/administrate-field-time_ago): :pencil: A `date_time` field that shows its data as `time_ago` since.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [XPBytes/administrate-serialized_fields](https://github.com/XPBytes/administrate-serialized_fields).
