source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'shipping_easy'
gem 'sinatra', '~> 2.0.0'
gem 'sinatra-logger', '>= 0.3.2'
gem 'tilt'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'

gem 'endpoint_base', github: 'misteral/endpoint_base'

group :test do
  gem 'rack-test', require: 'rack/test'
end

gemspec
