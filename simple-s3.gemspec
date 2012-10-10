# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "simple-s3/version"

Gem::Specification.new do |s|
  s.name        = "simple-s3"
  s.version     = SimpleS3::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matias Niemela"]
  s.email       = ["matias@yearofmoo.com"]
  s.homepage    = "https://github.com/yearofmoo/simple-s3"
  s.summary     = %q{Push your static content to S3}
  s.description = %q{This Gem allows you to push your static content to AWS S3.}

  s.default_executable = %q{simple-s3}

  s.add_dependency 'aws-s3'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
