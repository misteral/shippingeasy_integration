ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'shippingeasy_integration'
require 'rack/test'
require 'minitest/autorun'
require 'byebug'
