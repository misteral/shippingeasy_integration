module ShippingeasyIntegration
  class Service
    class << self
      def transform(payload)
        {
          shipping_easy: {
            order: {
              external_order_identifier: payload['display_number'],
              ordered_at: payload['placed_on'],
              custom_1: payload['delivery_date'],
              alternate_order_id: payload['id'],
              total_including_tax: payload['totals']['order'],
              recipients: [recipients(payload)]
            }
          }
        }
      end

      private

      def address(payload)
        address = payload.dig('shipping_address', 'address1')
        return 'Address placeholder, please fill.' if address.blank?

        address
      end

      def postal_code(payload)
        postal_code = payload.dig('shipping_address', 'zipcode')
        return 'Postal code placeholder, please fill.' if postal_code.blank?

        postal_code
      end

      def recipients(payload)
        { company: payload.dig('shipping_address', 'company'),
          first_name: payload.dig('shipping_address', 'firstname'),
          last_name: payload.dig('shipping_address', 'lastname'),
          address: address(payload),
          address2: payload.dig('shipping_address', 'address2'),
          city: payload.dig('shipping_address', 'city'),
          state: payload.dig('shipping_address', 'state'),
          country: payload.dig('shipping_address', 'country'),
          postal_code: postal_code(payload),
          phone_number: payload.dig('shipping_address', 'phone'),
          email: payload.dig('account', 'email'),
          line_items: line_items(payload) }
      end

      def line_items(payload)
        line_items = []
        payload['line_items'].each do |line_item|
          line_items << {
            weight_in_ounces: line_item['weight_in_ounces'],
            item_name: line_item['name'],
            sku: line_item['product_id'],
            quantity: line_item['quantity'],
            total_excluding_tax: line_item['price'],
            unit_price: line_item['price']
          }
        end
        line_items
      end
    end
  end
end
