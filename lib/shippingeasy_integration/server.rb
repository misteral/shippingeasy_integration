require 'sinatra'
require 'endpoint_base'

module ShippingeasyIntegration
  class Server < EndpointBase::Sinatra::Base
    get '/send_orders' do
      result 200, 'The order was imported correctly'
    end
  end
end
