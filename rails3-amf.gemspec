# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rails3-amf}
  s.version = "0.1.0"

  s.authors = ["Stephen Augenstein", "Reinaldo Junior"]
  s.email = %w{perl.programmer@gmail.com juniorz@gmail.com}
  s.date = %q{2010-09-23}
  s.homepage = %q{http://github.com/warhammerkid/rails3-amf}
  s.summary = %q{A Rails 3 plugin that provides tight rails amf integration}

  s.files = Dir["{lib}/**/*"] + ["README.rdoc", "Rakefile"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'railties',      '~> 3.1.0'
  s.add_dependency 'actionpack',    '~> 3.1.0'
  s.add_dependency 'activerecord',  '~> 3.1.0'
  s.add_dependency 'mime-types'
  s.add_dependency 'RocketAMF'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "rake", '~> 0.9.2'
  s.add_development_dependency "rspec", '~> 2.8.0'
end
