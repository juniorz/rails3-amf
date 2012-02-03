#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

Bundler::GemHelper.install_tasks
require 'rspec/core/rake_task'

desc 'Default: run the specs.'
task :default => :spec

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['--options', 'spec/spec.opts']
end
