require "spec_helper"

describe Moneybird::Service::Product do
  let(:client) { Moneybird::Client.new('bearer token') }
  let(:service) { Moneybird::Service::Product.new(client, '123') }

  describe "#all" do
    before do
      stub_request(:get, 'https://moneybird.com/api/v2/123/products')
        .to_return(status: 200, body: fixture_response(:products))
    end

    it "returns list of products" do
      products = service.all

      products.length.must_equal 1
      products.first.id.must_equal "143274140103607298"
    end
  end
end
