$:.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems' unless defined? Gem
require 'bundler'
Bundler.setup

require 'rails3-amf'