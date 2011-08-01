# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "abstract-sql/version"

Gem::Specification.new do |s|
  s.name        = "abstract-sql"
  s.version     = Abstract::Sql::VERSION
  s.authors     = ["Hallelujah"]
  s.email       = ["hery@rails-royce.org"]
  s.homepage    = "https://github.com/hallelujah/sql-abstract"
  s.summary     = %q{Transform a SQL statement to Perl SQL::Abstract JSON format}
  s.description = %q{It reverse an SQL statement to a Perl SQL::Abstract JSON format.}

  s.rubyforge_project = "abstract-sql"


  s.add_dependency 'parslet'
  s.add_development_dependency 'test-unit', '>= 2.1.0'
  s.add_development_dependency 'rcov'
  s.add_development_dependency 'rake'


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
