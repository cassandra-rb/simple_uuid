# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "simple_uuid"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0.8") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan King, Evan Weaver"]
  s.description = "Simple, scalable UUID generation."
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.rdoc", "lib/simple_uuid.rb"]
  s.files = ["CHANGELOG", "LICENSE", "Manifest", "README.rdoc", "Rakefile", "lib/simple_uuid.rb", "simple_uuid.gemspec", "test/test_uuid.rb"]
  s.homepage = "https://github.com/cassandra-rb/simple_uuid"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Simple_uuid", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Simple, scalable UUID generation."
  s.test_files = ["test/test_uuid.rb"]
  s.licenses = ['Apache']

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
