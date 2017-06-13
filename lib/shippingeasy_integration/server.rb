require 'sinatra'
require 'endpoint_base'
require 'shipping_easy'
require 'sinatra/logger'

module ShippingeasyIntegration
  class Server < EndpointBase::Sinatra::Base
    logger filename: "log/shipping_easy_integrator_#{settings.environment}.log",
           level: :trace

    before ['/cancel_order', '/create_order'] do
      logger.info "@config=#{@config}"
      logger.info "OrderInfo=#{@payload}"

      ShippingEasy.configure do |config|
        config.api_key = @config['api_key']
        config.api_secret = @config['api_secret']
      end
    end

    post '/update_order' do
      response = ShippingEasy::Resources::Cancellation
                 .create(store_api_key: @config['store_api_key'],
                         external_order_identifier: \
                     @payload[:shipping_easy][:order][:external_order_identifier])
      logger.info "Response from Shipping Easy when cancel = #{response}"

      response = ShippingEasy::Resources::Order
                 .create(store_api_key: @config['store_api_key'],
                         payload: @payload[:shipping_easy])
      logger.info "Response from Shipping Easy when create = #{response}"

      result 200, 'Order with is updated in Shipping Easy.'
    end

    post '/cancel_order' do
      begin
        response = ShippingEasy::Resources::Cancellation
                   .create(store_api_key: @config['store_api_key'],
                           external_order_identifier: \
                             @payload[:shipping_easy][:order][:external_order_identifier])

        logger.info "Response from Shipping Easy = #{response}"
        result 200, 'Order with is canceleed from Shipping Easy.'
      rescue => e
        logger.error e.cause
        logger.error e.backtrace.join("\n")
        result 500, e.message
      end
    end

    post '/create_order' do
      begin
        logger.info "@config=#{@config}"
        logger.info "OrderInfo=#{@payload[:shipping_easy]}"

        # ShippingEasy.configure do |config|
        #   config.api_key = @config['api_key']
        #   config.api_secret = @config['api_secret']
        # end

        response = ShippingEasy::Resources::Order.create(store_api_key: @config['store_api_key'],
                                                         payload: @payload[:shipping_easy])

        logger.info "Response from Shipping Easy = #{response}"

        # add_object 'order', @payload[:shipping_easy][:order].merge(shipping_easy_id: response['order']['id'])
        # result 200, "Order with #{response.payload[:shipping_easy][:order][:external_order_identifier]} is added to Shipping Easy."
        result 200, 'Order with is added to Shipping Easy.'
      rescue => e
        logger.error e.cause
        logger.error e.backtrace.join("\n")
        result 500, e.message
      end
    end
  end
end
