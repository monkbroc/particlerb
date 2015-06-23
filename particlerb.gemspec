# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'particle/version'

Gem::Specification.new do |spec|
  spec.authors = ["Julien Vanier"]
  spec.description = %q{Ruby client for the Particle.io API}
  spec.email = ['jvanier@gmail.com']
  spec.files = %w(LICENSE.txt README.md Rakefile particlerb.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.homepage = 'https://github.com/monkbroc/particlerb'
  spec.licenses = ['GPL-3.0']
  spec.name = 'particlerb'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.9.3'
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary = %q{Ruby client for the Particle.io API}
  spec.version = Particle::VERSION.dup
  spec.add_dependency 'sawyer', '~> 0.6.0'
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec', '~> 3.0.0'
  spec.add_development_dependency 'vcr', '~> 2.9.2'
  spec.add_development_dependency 'webmock', '~> 1.2.0'
end
