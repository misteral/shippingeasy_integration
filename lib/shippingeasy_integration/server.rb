require 'sinatra'
require 'endpoint_base'
require 'shipping_easy'
require 'sinatra/logger'

module ShippingeasyIntegration
  class Server < EndpointBase::Sinatra::Base
    logger filename: "log/shipping_easy_integrator_#{settings.environment}.log",
           level: :trace

    before ['/cancel_order', '/create_order'] do
      logger.info "Config=#{@config}"
      logger.info "Payload=#{@payload}"

      ShippingEasy.configure do |config|
        config.api_key = @config['api_key']
        config.api_secret = @config['api_secret']
      end
    end

    post '/order_callback' do
      logger.info "Config=#{@config}"
      logger.info "Payload=#{@payload}"

      puts "Config=#{@config}"
      puts "Payload=#{@payload}"
      # orders_from_payload = @payload['shipment']['orders']
      # orders_from_payload.each do |order_payload|
      #   add_object :order,  number: order_payload['external_order_identifier'],
      #                       tracking_number: @payload['shipment']['tracking_number'],
      #                       shipment_cost: @payload['shipment']['shipment_cost']
      # end
      result 200, 'Order from shiiping easy is updated'
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
        create_response = ShippingEasy::Resources::Order
                          .create(store_api_key: @config['store_api_key'],
                                  payload: @payload[:shipping_easy])
        logger.info "Create order response #{create_response}"

        result 200, 'Order with is added to Shipping Easy.'
      rescue => e
        logger.error e.cause
        logger.error e.backtrace.join("\n")
        result 500, e.message
      end
    end
  end
end
