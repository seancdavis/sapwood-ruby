
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sapwood/version'

Gem::Specification.new do |spec|
  spec.name          = 'Sapwood'
  spec.version       = Sapwood::VERSION
  spec.authors       = ['Sean C Davis']
  spec.email         = ['scdavis41@gmail.com']

  spec.summary       = %q{Ruby bindings for Sapwood's API}
  spec.description   = %q{A simple SDK for working with Sapwood's API.}
  spec.homepage      = 'https://github.com/seancdavis/sapwood-ruby'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'faker', '~> 1.8', '>= 1.8.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'dotenv-rails', '~> 2.2', '>= 2.2.0'
  spec.add_development_dependency 'pry', '~> 0.9', '>= 0.9.0'

  spec.add_dependency 'rest-client', '~> 2.0', '>= 2.0.0'
  spec.add_dependency 'activesupport', '~> 5.1', '>= 5.1.0'
end
