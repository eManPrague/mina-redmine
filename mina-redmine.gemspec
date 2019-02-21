# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mina/redmine/version'

Gem::Specification.new do |spec|
  spec.name          = "mina-redmine"
  spec.version       = Mina::Redmine::VERSION
  spec.authors       = ["Jan Strnadek"]
  spec.email         = ["jan.strnadek@gmail.com"]
  spec.summary       = "Announce Mina deploys to redmine"
  spec.description   = "Announce Mina deploys to redmine"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler"
  spec.add_dependency "rake"
  spec.add_dependency "net-ssh"

  spec.add_dependency "mina"

end
