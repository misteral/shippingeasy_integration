# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shippingeasy_integration/version'

Gem::Specification.new do |spec|
  spec.name          = 'shippingeasy_integration'
  spec.version       = ShippingeasyIntegration::VERSION
  spec.authors       = ['Alexander Bobrov']
  spec.email         = ['al.bobrov.mail@gmail.com']

  spec.summary       = 'Shippingeasy integration for cangaroo/wombat'
  spec.description   = 'Shippingeasy integration for cangaroo/wombat'
  spec.homepage      = 'http://github.com/misteral/shippingeasy_integration'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing
  # to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'sinatra', '~> 2.0.0'
  spec.add_dependency 'tilt', '~> 2.0.7'
  spec.add_dependency 'tilt-jbuilder', '~> 0.7.1'
  spec.add_dependency 'endpoint_base', '~> 0.3'
  spec.add_dependency 'shipping_easy', '~> 0.7.0'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rack-test', '~> 0.6.3'
  spec.add_development_dependency 'byebug', '~> 9.0.6'
end
