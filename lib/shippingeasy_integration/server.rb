require 'sinatra'
require 'endpoint_base'
require 'shipping_easy'
require 'sinatra/logger'

module ShippingeasyIntegration
  class Server < EndpointBase::Sinatra::Base
    logger filename: "log/shipping_easy_integrator_#{settings.environment}.log", level: :trace

    post '/create_order' do

      logger.info "@config=#{@config}"
      logger.info "OrderInfo=#{@payload[:shipping_easy]}"

      ShippingEasy.configure do |config|
        config.api_key = @config['api_key']
        config.api_secret = @config['api_secret']
      end

    #   byebug
      # if ENV['RAILS_ENV'] == 'development'

      # end
      result = ShippingEasy::Resources::Order.create(store_api_key: @config['store_api_key'],
                                                     payload: @payload[:shipping_easy])

      logger.info "Response from Shipping Easy = #{result}"

      result 200, 'Succesfully Create Order'
    end
  end
end
