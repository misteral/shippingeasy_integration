require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)
require './shippingeasy_integration'
run SippingEasyEndpoint
