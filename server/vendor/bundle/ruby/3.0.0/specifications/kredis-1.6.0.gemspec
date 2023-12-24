# -*- encoding: utf-8 -*-
# stub: kredis 1.6.0 ruby lib

Gem::Specification.new do |s|
  s.name = "kredis".freeze
  s.version = "1.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kasper Timm Hansen".freeze, "David Heinemeier Hansson".freeze]
  s.date = "2023-10-19"
  s.email = "david@hey.com".freeze
  s.homepage = "https://github.com/rails/kredis".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7.0".freeze)
  s.rubygems_version = "3.2.33".freeze
  s.summary = "Higher-level data structures built on Redis.".freeze

  s.installed_by_version = "3.2.33" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 6.0.0"])
    s.add_runtime_dependency(%q<activemodel>.freeze, [">= 6.0.0"])
    s.add_runtime_dependency(%q<redis>.freeze, [">= 4.2", "< 6"])
    s.add_development_dependency(%q<rails>.freeze, [">= 6.0.0"])
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 6.0.0"])
    s.add_dependency(%q<activemodel>.freeze, [">= 6.0.0"])
    s.add_dependency(%q<redis>.freeze, [">= 4.2", "< 6"])
    s.add_dependency(%q<rails>.freeze, [">= 6.0.0"])
  end
end
