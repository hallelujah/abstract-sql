# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler.setup
require 'test/unit'


$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'abstract-sql'
class Test::Unit::TestCase
end
