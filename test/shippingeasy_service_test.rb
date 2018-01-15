require 'test_helper'

describe ShippingeasyIntegration::Service do
  # make_my_diffs_pretty!

  before do
    @subject = ShippingeasyIntegration::Service
  end

  describe '.transform' do
    it 'return data in right structure' do
      payload = parse_fixture('sweet_integrator_payload.json')

      data = @subject.transform(payload['order'])[:shipping_easy][:order]

      data[:recipients].count.must_be :>, 0
      data[:recipients].first[:line_items].size.must_be :>, 1
      data[:recipients].first[:line_items].first[:item_name].wont_be_empty
      data[:external_order_identifier].wont_be_empty
      data[:ordered_at].wont_be_empty
      data[:recipients].first[:address].wont_be_empty
      data[:recipients].first[:postal_code].wont_be_empty
    end
  end
end
