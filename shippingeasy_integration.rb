class SippingEasyEndpoint < EndpointBase::Sinatra::Base
  post '/send_orders' do
    result 200, 'The order was imported correctly'
  end
end
