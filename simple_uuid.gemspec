# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simple_uuid}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0.8") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Ryan King, Evan Weaver}]
  s.date = %q{2011-08-19}
  s.description = %q{Simple, scalable UUID generation.}
  s.email = %q{ryan@twitter.com}
  s.extra_rdoc_files = [%q{CHANGELOG}, %q{LICENSE}, %q{README.rdoc}, %q{lib/simple_uuid.rb}]
  s.files = [%q{CHANGELOG}, %q{LICENSE}, %q{Manifest}, %q{README.rdoc}, %q{Rakefile}, %q{lib/simple_uuid.rb}, %q{test/test_uuid.rb}, %q{simple_uuid.gemspec}]
  s.homepage = %q{http://fauna.github.com/fauna/simple_uuid/}
  s.rdoc_options = [%q{--line-numbers}, %q{--inline-source}, %q{--title}, %q{Simple_uuid}, %q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{fauna}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Simple, scalable UUID generation.}
  s.test_files = [%q{test/test_uuid.rb}]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
