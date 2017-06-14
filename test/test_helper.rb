ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'shippingeasy_integration'
require 'rack/test'
require 'minitest/mock'
require 'minitest/autorun'
require 'pry'

def load_fixture(filename)
  File.read(File.expand_path("../fixtures/#{filename}", __FILE__))
end

def parse_fixture(filename)
  JSON.parse(load_fixture(filename))
end
