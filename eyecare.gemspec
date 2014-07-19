# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eyecare/version'

Gem::Specification.new do |spec|
  spec.name          = "eyecare"
  spec.version       = Eyecare::VERSION
  spec.authors       = ["Viorel Craescu"]
  spec.email         = ["viorel@craescu.com"]
  spec.summary       = %q{Protect your eyes}
  spec.description   = %q{Protect your eyes}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'ffi'
  spec.add_dependency 'libnotify'
  spec.add_dependency 'chronic_duration'
  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
end
