# -*- encoding: utf-8 -*-
# stub: marky_markov 0.3.5 ruby lib

Gem::Specification.new do |s|
  s.name = "marky_markov".freeze
  s.version = "0.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Matt Furden".freeze]
  s.date = "2014-03-17"
  s.description = "MarkyMarkov makes it easy to generate simply Markov Chains based upon input from\n  either a source file or a string. While usable as a module in your code it can also be called on\n  from the command line and piped into like a standard UNIX application.".freeze
  s.email = "mfurden@gmail.com".freeze
  s.executables = ["marky_markov".freeze]
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze, "bin/marky_markov".freeze]
  s.homepage = "https://github.com/zolrath/marky_markov".freeze
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubygems_version = "3.2.33".freeze
  s.summary = "Simple Markov Chain generation available in the command-line".freeze

  s.installed_by_version = "3.2.33" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 2
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<msgpack>.freeze, [">= 0"])
  else
    s.add_dependency(%q<msgpack>.freeze, [">= 0"])
  end
end
