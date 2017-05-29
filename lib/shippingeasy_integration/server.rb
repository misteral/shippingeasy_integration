require 'sinatra'
require 'endpoint_base'
require 'shipping_easy'

module ShippingeasyIntegration
  class Server < EndpointBase::Sinatra::Base
    set :logging, true

    post '/create_order' do
    #   ShippingEasy.configure do |config|
    #     config.api_key = @config['api_key']
    #     config.api_secret = @config['api_secret']
    #   end

    #   byebug
      # if ENV['RAILS_ENV'] == 'development'
        puts "@config=#{@config}"
        puts "@payload=#{@payload}"
      # end
    #   ShippingEasy::Resources::Order.create(store_api_key: @config['api_key'],
    #                                         payload: @payload)

      result 200, 'Succesfully Create Order'
    end
  end
end
