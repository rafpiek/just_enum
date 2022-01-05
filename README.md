# JustEnum

This gem has been created to mimic Typescript like enums and adding additional features to the POROs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'just_enum'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install just_enum

## Usage

### Defining enums

After installing gem extend the class you want to make the enum for storing properties with `JustEnum::Base`.

For example:
```ruby
class ButtonType < JustEnum::Base
  enum %i[primary secondary]
end

class Color < JustEnum::Base
  enum %i[success danger]
end

class Labels < JustEnum::Base
  enum save: "Zapisz", cancel: "Anuluj"
end
```

So that you can have enum classes as Ruby singletons. You can use:
```ruby
ButtonType.primary #=> 0
ButtonType.secondary #=> 1
Color.success #=> 0
Color.danger #=> 1
Labels.save #=> "Zapisz"
Labels.cancel #=> "Anuluj"
```

You can list all possible options in the enum by using `.options` static method
```ruby
ButtonType.options #=> [:primary, :secondary]
Color.options #=> {:success=>"success", :danger=>"danger"}
Labels.options #=> {:save=>"Zapisz", :cancel=>"Anuluj"}
```

### How enums are defined in JustEnum
#### Indexed enum
```ruby
class ButtonType < JustEnum::Base
  enum %i[primary secondary]
end
```

```ruby
enum %i[primary secondary]

# is the same as:

{ primary: 0, secondary: 1 }
```

#### Enum with custom values
You can define custom values for enums

```ruby
class Labels < JustEnum::Enum
  enum save: "Zapisz", cancel: "Anuluj"
end
```

```ruby
enum({ save: "Zapisz", cancel: "Anuluj" })

# is the same as:

{ save: "Zapisz", cancel: "Anuluj" }
```

#### Mirrored enum keys
You can mirror your keys as the values in enum.

```ruby
class Color < JustEnum::Base
  enum %i[success danger], mirror: true
end
```

```ruby
enum %i[success danger], mirror: true

# is the same as:

{ success: "success", danger: "danger" }
```

### Use defined enums as values in your PORO classes.

Than You can use the enum to define values for fields in your PORO classes. Do it by extending your 
class with `JustEnum::Enum`

```ruby
class ButtonPrimary
  extend JustEnum::Enum
  enumerate :type, ButtonType, ButtonType.primary
  enumerate :color, Color, Color.success
  enumerate :label, Labels, Labels.save
end
```

You can also omit the `extend` directive and use it in traditional way in constructor or `attr_writer`.

```ruby
class ButtonPrimary
  def initialize(type, color, label)
    @type = ButtonType.primary
    @color = Color.success
    @label = Labels.save
  end
end
```

### Extend your class with `JustEnum::Enum`
When extending your PORO with `JustEnum::Enum`:

a) you can access the `enumarate` method which defines instance fields with values provided by enums
```ruby
class ButtonPrimary
  extend JustEnum::Enum
  enumerate :type, ButtonType, ButtonType.primary
  enumerate :color, Color, Color.success
  enumerate :label, Labels, Labels.save
end
```

b) you have public underscored accessors for defined fields which will return the Enum definition as
complex type

```ruby
button = ButtonPrimary.new

button._type #=> ButtonType.primary
button._color #=> Color.success
button._label #=> Labels.save
```

c) you have the string representation of defined enumerated fields with `str_` prefix

```ruby
button = ButtonPrimary.new

button.str_type #=> 'primary'
button.str_color #=> 'success'
button.str_label #=> 'Zapisz'
```

d) you have boolean methods allowing to check which enum value has been defined or in other words:
of what enum is the field in your PORO class

```ruby
button = ButtonPrimary.new

button.button_type_primary? #=> true
button.button_type_secondary? #=> false
button.color_success? #=> true
button.color_danger? #=> false
button.label_save? #=> true
button.label_cancel? #=> false
```

### Usage with ViewComponent
It's very convenient to use JustEnum with [ViewComponent gem from Github](https://github.com/github/view_component)
You can define your enum classes:
```ruby
module Enums
  class ButtonType < JustEnum::Base
    enum %i[primary secondary default success]
  end
end
```

Then extend your component classes with `JustEnum::Enum`
```ruby
# frozen_string_literal: true

class ButtonPrimary < ViewComponent::Base
  extend JustEnum::Enum
  enumerate :type, ButtonType, ButtonType.primary
  
  attr_reader :label
  
  def initialize(label:)
    @label = label
  end
end

<%= render ButtonPrimary.new(label: "Start search") %>
```

Or you can go one step further and encapsulate enums in static methods

```ruby
# frozen_string_literal: true

class Button < ViewComponent::Base
  include Enums::ButtonType::Enum

  class << self
    def primary(**args)
      args[:type_class] = %w[border-transparent text-white bg-indigo-600 hover:bg-indigo-700]
      new(**args, type: Enums::ButtonType.primary)
    end

    def secondary(**args)
      new(**args, type: Enums::ButtonType.secondary)
    end

    def default(**args)
      args[:type_class] = %w[bg-white border-gray-300 text-gray-700 hover:bg-gray-5]
      new(**args, type: Enums::ButtonType.default)
    end

    def success(**args)
      new(**args, type: Enums::ButtonType.success)
    end
  end

  attr_reader :label,

  def initialize(label:, type:)
    @type = args[:type] || Enums::ButtonType.default
    @label = args[:label]
  end
end

<%= render Button.default(label: "Cancel") %>
<%= render Button.primary(label: "Start search") %>

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rafpiek/just_enum.
