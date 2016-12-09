# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sapwood/version'

Gem::Specification.new do |spec|
  spec.name          = "sapwood"
  spec.version       = Sapwood::VERSION
  spec.authors       = ["Sean C Davis"]
  spec.email         = ["scdavis41@gmail.com"]

  spec.summary       = %q{Ruby bindings for Sapwood's API}
  spec.description   = %q{The Sapwood gem is a simple SDK for working with the API of a Sapwood server.}
  spec.homepage      = "https://github.com/seancdavis/sapwood-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.13"
  spec.add_development_dependency "rake"
  # spec.add_development_dependency "rspec"

  spec.add_dependency "httparty", ">= 0.14.0"
end
