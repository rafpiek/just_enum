require_relative 'string'
module JustEnum::Enum
  def enumerate(field_key, enum_class, field_value)
    has_hash_options = enum_class.options.is_a? Hash
    if has_hash_options
      define_method("str_#{field_key.to_s}") { enum_class.options[field_value.to_sym] }
      enum_class.options.each_pair do |key, value|
        define_method("#{enum_class.name.snakecase}_#{key.to_s}?") { field_value == value }
      end
    else
      define_method("str_#{field_key.to_s}") { enum_class.options[field_value].to_s }
      enum_class.options.each_with_index do |opt, index|
        define_method("#{enum_class.name.snakecase}_#{opt.to_s}?") { field_value == index }
      end
    end
    define_method("_#{field_key.to_s}") { field_value }
  end
end
