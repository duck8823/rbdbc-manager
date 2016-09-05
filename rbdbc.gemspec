# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbdbc/version.rb'

Gem::Specification.new do |spec|
	spec.name          = 'rbdbc'
	spec.version       = Rbdbc::VERSION
	spec.authors       = ['shunsuke maeda']
	spec.email         = ['duck8823@gmail.com']

	spec.summary       = %q{構造体で簡易データベース操作}
	spec.description   = %q{}
	spec.homepage      = 'https://github.com/duck8823/rbdbc-manager.git'
	spec.license       = 'MIT'


	spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ['lib']

	spec.add_development_dependency 'bundler', '~> 1.12'
	spec.add_development_dependency 'rake', '~> 10.0'
	spec.add_development_dependency 'rspec', '~> 3.0'

	spec.add_runtime_dependency 'dbi'
	spec.add_runtime_dependency 'dbd-pg'
	spec.add_runtime_dependency 'dbd-sqlite3'

	spec.add_development_dependency 'simplecov'
	spec.add_development_dependency 'minitest'
end