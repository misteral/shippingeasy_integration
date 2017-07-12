require 'test_helper'

class ShippingeasyIntegrationTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ShippingeasyIntegration::Server
  end

  def test_that_it_has_a_version_number
    refute_nil ::ShippingeasyIntegration::VERSION
  end

  def test_tespond_ok_for_root
    get '/'
    assert last_response.ok?
  end

  def test_respond_ok_for_callback
    payload = load_fixture('callback_payload.json')
    mock = Minitest::Mock.new
    def mock.code; 202; end

    HTTParty.stub :post, mock do
      post '/order_callback', payload
    end

    assert last_response.ok?
    parsed_body = JSON.parse(last_response.body)
    order_body = parsed_body['orders'].first

    assert parsed_body['orders'].size == 1
    assert_equal order_body['id'], 'R1-R572547556'
  end

  def test_respond_for_update_order
    payload = load_fixture('sweet_integrator_payload.json')
    order_find_response = parse_fixture('order_find_response.json')
    order_create_response = parse_fixture('order_create_response.json')

    ShippingEasy::Resources::Cancellation.stub :create, ok: 'ok' do
      ShippingEasy::Resources::Order.stub :find, order_find_response do
        ShippingEasy::Resources::Order.stub :create, order_create_response do
          post '/update_order', payload

          assert last_response.ok?
          parsed_body = JSON.parse(last_response.body)['orders'].first

          refute_nil parsed_body['id']
          refute_nil parsed_body['sync_id']
          assert_equal parsed_body['sync_type'], 'shipping_easy'
          assert_equal parsed_body['id'], 'R1-R572547556'
        end
      end
    end
  end

  def test_respond_ok_for_create_order
    payload = load_fixture('sweet_integrator_payload.json')
    order_create_response = parse_fixture('order_create_response.json')
    ShippingEasy::Resources::Order.stub :create, order_create_response do
      post '/create_order', payload

      assert last_response.ok?
      parsed_body = JSON.parse(last_response.body)['orders'].first

      refute_nil parsed_body['id']
      refute_nil parsed_body['sync_id']
      assert_equal parsed_body['sync_type'], 'shipping_easy'
      assert_equal parsed_body['id'], 'R1-R572547556'
    end
  end

  def test_respond_ok_for_cancel_order
    payload = load_fixture('sweet_integrator_payload.json')
    ShippingEasy::Resources::Order
      .stub :find, 'order' => { 'external_order_identifier' => '3' } do

      ShippingEasy::Resources::Cancellation.stub :create, ok: 'ok' do
        post '/cancel_order', payload

        assert last_response.ok?
      end
    end
  end
end
