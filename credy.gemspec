# -*- encoding: utf-8 -*-

require File.expand_path '../lib/credy/version', __FILE__

Gem::Specification.new do |s|
  s.authors       = ['Tim Petricola']
  s.email         = ['hi@timpetricola.com']
  s.summary       = %q{A simple (but powerful) credit card number generator}
  s.homepage      = 'https://github.com/TimPetricola/Credy'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files         = `git ls-files`.split "\n"
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split "\n"
  s.name          = 'credy'
  s.require_paths = ['lib']
  s.version       = Credy::VERSION

  s.add_development_dependency 'rspec', '~> 2.12.0'
  s.add_development_dependency 'rake', '~> 10.0.3'
  s.add_runtime_dependency 'thor', '~> 0.17.0'
end
