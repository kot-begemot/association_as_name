# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "a_a_n/version"

Gem::Specification.new do |s|
  s.name        = "a_a_n"
  s.version     = AAN::VERSION
  s.authors     = ["E-Max"]
  s.email       = ["max@studentify.nl"]
  s.homepage    = "https://github.com/Studentify/association_as_name"
  s.summary     = %q{Association as name}
  s.description = %q{Whenever you need assign an association by its attribute,
 like name, this gem comes to busines.}

  s.rubyforge_project = "a_a_n"

  s.files         = ["README",
                     "a_a_n.gemspec",
                     "Gemfile",
                     "Rakefile",
                     "lib/a_a_n.rb",
                     "lib/a_a_n/association_as_name.rb",
                     "lib/a_a_n/version.rb"]
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("activesupport", ">= 3.0.0")
  s.add_dependency("activerecord", ">= 3.0.0")
end
