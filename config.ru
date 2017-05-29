# require 'rubygems'
# require 'bundler/setup'

# Bundler.require(:default)

$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')
require 'shippingeasy_integration/server'

run ShippingeasyIntegration::Server
