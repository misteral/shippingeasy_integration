require 'sinatra'
require 'endpoint_base'
require 'shipping_easy'
require 'logger'
# require 'sinatra/logger'

module ShippingeasyIntegration
  class Server < EndpointBase::Sinatra::Base
    before ['/cancel_order', '/create_order', '/update_order'] do
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

      orders_from_payload = @payload['shipment']['orders']
      orders_from_payload.each do |order_payload|
        add_object :order,  id: order_payload['external_order_identifier'],
                            tracking_number: @payload['shipment']['tracking_number'],
                            shipment_cost: @payload['shipment']['shipment_cost']
      end
      result 200, 'Order from callback'
    end

    post '/update_order' do
      begin
        # find order
        order =
          ShippingEasy::Resources::Order
          .find(
            id: @payload[:shipping_easy][:order][:sync_id]
          )

        # cancel order
        ShippingEasy::Resources::Cancellation
          .create(store_api_key: @config['store_api_key'],
                  external_order_identifier: \
          order['order']['external_order_identifier'])

        # create order
        new_identifier = modify_indentifier(order['order']['external_order_identifier'])
        @payload[:shipping_easy][:order][:external_order_identifier] = new_identifier
        new_order = ShippingEasy::Resources::Order
                    .create(store_api_key: @config['store_api_key'],
                            payload: @payload[:shipping_easy])

        # response part
        add_object :order, id: demodify_identyfier(new_order['order']['external_order_identifier']),
                           sync_id: new_order['order']['id'], sync_type: 'shipping_easy'
        result 200, 'Order with is updated from Shipping Easy'
      rescue => e
        logger.error e.cause
        logger.error e.backtrace.join("\n")
        result 500, e.message
      end
    end

    post '/cancel_order' do
      begin
        if @payload[:shipping_easy][:order][:sync_id]
          # find order
          order =
            ShippingEasy::Resources::Order
            .find(
              id: @payload[:shipping_easy][:order][:sync_id]
            )

          # cancel order
          response =
            ShippingEasy::Resources::Cancellation
            .create(store_api_key: @config['store_api_key'],
                    external_order_identifier: \
              order['order']['external_order_identifier'])
        else
          response =
            ShippingEasy::Resources::Cancellation
            .create(store_api_key: @config['store_api_key'],
                    external_order_identifier: \
              @payload[:shipping_easy][:order][:external_order_identifier])
        end

        logger.info "Response from Shipping Easy = #{response}"
        result 200, 'Order with is canceled from Shipping Easy.'
      rescue => e
        logger.error e.cause
        logger.error e.backtrace.join("\n")
        result 500, e.message
      end
    end

    post '/create_order' do
      begin
        new_order = ShippingEasy::Resources::Order
                    .create(store_api_key: @config['store_api_key'],
                            payload: @payload[:shipping_easy])

        add_object :order, id: demodify_identyfier(new_order['order']['external_order_identifier']),
                           sync_id: new_order['order']['id'], sync_type: 'shipping_easy'

        logger.info "Create order response #{new_order}"

        result 200, 'Order with is added to Shipping Easy.'
      rescue => e
        logger.error e.cause
        logger.error e.backtrace.join("\n")
        result 500, e.message
      end
    end

    def logger
      Logger.new(STDOUT)
    end

    def modify_indentifier(order_number)
      return "#{order_number}_1" if order_number.partition('_').last.empty?
      order_number_prefix = order_number.partition('_').last.to_i + 1
      "#{demodify_identyfier(order_number)}_#{order_number_prefix}"
    end

    def demodify_identyfier(modified_number)
      modified_number.partition('_').first
    end
  end
end
