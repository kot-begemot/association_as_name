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
  s.description = %q{Thi gem quite handy when one needs to assign an object by
string value in the form. Eg. country can by assigned by country name.
  }

  s.rubyforge_project = "a_a_n"

  s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "active_record"
  # s.add_runtime_dependency "rest-client"
end
