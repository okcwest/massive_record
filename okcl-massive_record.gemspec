# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "massive_record/version"

Gem::Specification.new do |s|
  s.name              = "okcl-massive_record"
  s.version           = MassiveRecord::VERSION
  s.platform          = Gem::Platform::RUBY
  s.authors           = ["Companybook"]
  s.email             = %q{keyes@okcupidlabs.com}
  s.homepage          = %q{http://github.com/okcwest/massive_record}
  s.summary           = %q{HBase Ruby client API}
  s.description       = %q{HBase Ruby client API}
  s.rubyforge_project = "massive_record"


  s.add_dependency "thrift", "~> 0.8.0"
  s.add_dependency "activesupport", "~> 3.2.6"
  s.add_dependency "activemodel", "~> 3.2.6"
  s.add_dependency "memoist"
  s.add_dependency "tzinfo"
  s.add_dependency "awesome_print"

  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
