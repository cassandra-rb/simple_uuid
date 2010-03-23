# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simple_uuid}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0.8") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan King, Evan Weaver"]
  s.cert_chain = ["/Users/ryan/.gemkeys/gem-public_cert.pem"]
  s.date = %q{2010-03-23}
  s.description = %q{Simple, scalable UUID generation.}
  s.email = %q{ryan@twitter.com}
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.rdoc", "lib/simple_uuid.rb"]
  s.files = ["CHANGELOG", "LICENSE", "Manifest", "README.rdoc", "Rakefile", "lib/simple_uuid.rb", "simple_uuid.gemspec", "test/test_uuid.rb"]
  s.homepage = %q{http://blog.evanweaver.com/files/doc/fauna/simple_uuid/}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Simple_uuid", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{fauna}
  s.rubygems_version = %q{1.3.5}
  s.signing_key = %q{/Users/ryan/.gemkeys/gem-private_key.pem}
  s.summary = %q{Simple, scalable UUID generation.}
  s.test_files = ["test/test_uuid.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
