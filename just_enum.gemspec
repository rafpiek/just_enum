# frozen_string_literal: true

require_relative "lib/just_enum/version"
lib = File.expand_path('lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "just_enum"
  spec.version       = JustEnum::VERSION
  spec.authors       = ["Rafal Piekara"]
  spec.email         = ["rafal@piekara.me"]

  spec.summary       = "Simple enum module extending Ruby with TypeScript like enums"
  spec.description   = "Module extends PORO classes in enums and generate helpers for other POROS using those enums"
  spec.homepage      = "https://github.com/rafpiek/just_enum"
  spec.required_ruby_version = ">= 2.4.0"


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rafpiek/just_enum"
  spec.metadata["changelog_uri"] = "https://github.com/rafpiek/just_enum"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
