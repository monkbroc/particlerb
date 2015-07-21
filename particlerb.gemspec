# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'particle/version'

Gem::Specification.new do |spec|
  spec.authors = ["Julien Vanier"]
  spec.summary = %q{Ruby client for the Particle.io Cloud API}
  spec.description = %q{Ruby client for the Particle.io Cloud API}
  spec.email = ['jvanier@gmail.com']
  spec.files = %w(LICENSE.txt README.md Rakefile particlerb.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.homepage = 'https://github.com/monkbroc/particlerb'
  spec.licenses = ['LGPL-3.0']
  spec.name = 'particlerb'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.9.3'
  spec.required_rubygems_version = '>= 1.3.5'
  spec.version = Particle::VERSION.dup
  spec.add_dependency 'faraday', '~> 0.9.0'
  spec.add_dependency 'faraday_middleware', '>= 0.9.0'
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-pride', '~> 3.1'
  spec.add_development_dependency 'vcr', '~> 2.9'
  spec.add_development_dependency 'webmock', '~> 1.21'
  spec.add_development_dependency 'multi_json', '~> 1.11'
  spec.add_development_dependency 'highline', '~> 1.7'
end
