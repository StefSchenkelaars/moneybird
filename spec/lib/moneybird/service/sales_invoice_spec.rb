require "spec_helper"

describe Moneybird::Service::SalesInvoice do
  let(:client) { Moneybird::Client.new('bearer token') }
  let(:service) { Moneybird::Service::SalesInvoice.new(client, '123') }

  describe "#all" do
    before do
      stub_request(:get, 'https://moneybird.com/api/v2/123/sales_invoices')
        .to_return(status: 200, body: fixture_response(:sales_invoices))
    end

    it "returns list of sales_invoices" do
      sales_invoices = service.all

      sales_invoices.length.must_equal 3
      sales_invoices.first.id.must_equal "194733567493801235"
    end
  end
end
