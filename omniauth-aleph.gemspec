# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth/aleph/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name     = 'omniauth-aleph'
  gem.version  = OmniAuth::Aleph::VERSION
  gem.authors  = ['Scot Dalton']
  gem.email    = ['scotdalton@gmail.com']
  gem.summary  = 'Aleph Patron Login Strategy for OmniAuth'
  gem.homepage = 'https://github.com/scotdalton/omniauth-aleph'
  gem.license  = 'MIT'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'omniauth', '~> 1.2'
  gem.add_runtime_dependency 'faraday', '~> 0.9'
  gem.add_runtime_dependency 'multi_xml', '~> 0.5'

  gem.add_development_dependency 'rake', '>= 10.1.0', '~> 11'
  gem.add_development_dependency 'rspec', '>= 2.14.0', '< 4'
  gem.add_development_dependency 'rack-test', '~> 0.6'
  gem.add_development_dependency 'webmock', '>= 1.17.0', '< 4'
  gem.add_development_dependency 'vcr', '>= 2.8.0', '< 4'
end
