require 'test_helper'

class ShippingeasyIntegrationTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ShippingeasyIntegration::Server
  end

  def data
    { 'type' => 'orders', 'payload' => { 'id' => 'R395577697', 'status' => 'approved', 'channel' => 'sweet', 'email' => 'darion_schmitt-haley_bakery@sweetist.co', 'currency' => 'USD', 'placed_on' => '2017-05-29T12:02:33Z', 'updated_at' => '2017-05-29T12:02:33Z', 'totals' => { 'item' => 261.62, 'adjustment' => 0.0, 'tax' => 0.0, 'shipping' => 0.0, 'payment' => 0.0, 'order' => 261.62 }, 'adjustments' => [{ 'name' => 'discount', 'value' => 0.0 }, { 'name' => 'tax', 'value' => 0.0 }, { 'name' => 'shipping', 'value' => 0.0 }], 'guest_token' => 'AyAaO_cjqK4_kTCc5-2ZeA1496059330969', 'shipping_instructions' => ' ', 'line_items' => [{ 'id' => 477, 'product_id' => '60645094', 'name' => 'Deep-Fried Apple & Lavender Trout', 'quantity' => 1, 'price' => 78.78 }, { 'id' => 478, 'product_id' => '61220540', 'name' => 'Apple Pud', 'quantity' => 2, 'price' => 91.42 }], 'payments' => [], 'promotions' => [], 'shipping_address' => nil, 'billing_address' => nil } }
  end

  def test_that_it_has_a_version_number
    refute_nil ::ShippingeasyIntegration::VERSION
  end

  def test_tespond_ok_for_root
    get '/'
    assert last_response.ok?
  end

  def test_respond_ok_for_send_orders
    post '/create_order', data.to_json

    assert last_response.ok?
  end
end
