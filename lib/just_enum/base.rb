module JustEnum
  class Base
    class << self
      def enum(options, mirror: false)
        if mirror
          options = options.each_with_object({}) do |i, hash|
            hash[i] = i.to_s
          end
        end
        define_singleton_method(:mirrored?) { mirror }
        define_singleton_method(:options) { options }
        case options
        when Array
          options.each_with_index do |opt, index|
            define_singleton_method(opt) { index }
          end
        when Hash
          options.each_pair do |key, value|
            define_singleton_method(key) { value }
          end
        end

      end
    end
  end
end
