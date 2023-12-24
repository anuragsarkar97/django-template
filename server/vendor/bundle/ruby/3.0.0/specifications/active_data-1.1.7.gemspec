# -*- encoding: utf-8 -*-
# stub: active_data 1.1.7 ruby lib

Gem::Specification.new do |s|
  s.name = "active_data".freeze
  s.version = "1.1.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["pyromaniac".freeze]
  s.date = "2020-08-20"
  s.description = "Making object from any hash or hash array".freeze
  s.email = ["kinwizard@gmail.com".freeze]
  s.homepage = "".freeze
  s.rubygems_version = "3.2.33".freeze
  s.summary = "Working with hashes in AR style".freeze

  s.installed_by_version = "3.2.33" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<actionpack>.freeze, [">= 4.0"])
    s.add_development_dependency(%q<activerecord>.freeze, [">= 4.0"])
    s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
    s.add_development_dependency(%q<database_cleaner>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.7.0"])
    s.add_development_dependency(%q<rspec-its>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop>.freeze, ["= 0.52.1"])
    s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_development_dependency(%q<uuidtools>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<activemodel>.freeze, [">= 4.0"])
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 4.0"])
    s.add_runtime_dependency(%q<tzinfo>.freeze, [">= 0"])
  else
    s.add_dependency(%q<actionpack>.freeze, [">= 4.0"])
    s.add_dependency(%q<activerecord>.freeze, [">= 4.0"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    s.add_dependency(%q<database_cleaner>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.7.0"])
    s.add_dependency(%q<rspec-its>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, ["= 0.52.1"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<uuidtools>.freeze, [">= 0"])
    s.add_dependency(%q<activemodel>.freeze, [">= 4.0"])
    s.add_dependency(%q<activesupport>.freeze, [">= 4.0"])
    s.add_dependency(%q<tzinfo>.freeze, [">= 0"])
  end
end
