# -*- encoding: utf-8 -*-

require File.expand_path '../lib/credy/version', __FILE__

Gem::Specification.new do |s|
  s.authors       = ['Tim Petricola']
  s.email         = ['hi@timpetricola.com']
  s.summary       = 'Simple credit card number generator'
  s.license       = 'MIT'
  s.homepage      = 'https://github.com/TimPetricola/Credy'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files         = `git ls-files`.split "\n"
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split "\n"
  s.name          = 'credy'
  s.require_paths = ['lib']
  s.version       = Credy::VERSION

  s.add_development_dependency 'rspec', '~> 3.3.0'
  s.add_development_dependency 'rake', '~> 10.4.2'
  s.add_runtime_dependency 'thor', '~> 0.19.1'
end
