# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'puppetdb_rundeck'
  spec.version       = '1.0.1'
  spec.authors       = ['liamjbennett']
  spec.email         = ['lbennett@opentable.com']
  spec.summary       = %q{A sinatra based application to provide integration between PuppetDB and Rundeck}
  spec.description   = %q{puppetdb_rundeck is a sinatra based application to provide integration between PuppetDB and Rundeck.
It provides an api in either xml, json or yaml that allows the node and fact data with puppetdb to use used as a resource
with rundeck}
  spec.homepage      = 'https://github.com/opentable/puppetdb_rundeck'
  spec.license       = 'MIT'

  spec.files = `git ls-files`.split("\n")
  spec.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.2'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'builder'

  spec.add_runtime_dependency 'json_pure', '~> 1.8'
  spec.add_runtime_dependency 'tilt', '~> 1.3'
  spec.add_runtime_dependency 'sinatra', '~> 1.4'
  spec.add_runtime_dependency 'haml', '~> 4.0'
  spec.add_runtime_dependency 'thread', '~> 0.1'
end
