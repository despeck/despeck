# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'despeck/version'

Gem::Specification.new do |spec|
  spec.name          = 'despeck'
  spec.version       = Despeck::VERSION
  spec.authors       = ['Ribose Inc.']
  spec.email         = ['open.source@ribose.com']

  spec.summary       = 'Removes stamps and watermarks '\
                       "from scanned images for OCR, 'removes specks'"
  spec.description   = 'Removes stamps and watermarks '\
                       "from scanned images for OCR, 'removes specks'"

  spec.homepage      = 'https://github.com/riboseinc/despeck'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.4'

  spec.add_dependency 'clamp', '~> 1.3'
  spec.add_dependency 'pdf-reader', '~> 2.1'
  spec.add_dependency 'prawn', '~> 2.2'
  spec.add_dependency 'rmagick', '~> 4.0'
  spec.add_dependency 'rtesseract', '~> 3.1'
  spec.add_dependency 'ruby-vips', '~> 2.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.81.0'
end
