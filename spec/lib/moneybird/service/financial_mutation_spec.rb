require "spec_helper"

describe Moneybird::Service::FinancialMutation do
  let(:client) { Moneybird::Client.new('bearer token') }
  let(:service) { Moneybird::Service::FinancialMutation.new(client, '123') }

  describe "#all" do
    before do
      stub_request(:get, 'https://moneybird.com/api/v2/123/financial_mutations')
        .to_return(status: 200, body: fixture_response(:financial_mutations))
    end

    it "returns list of financial_mutations" do
      financial_mutations = service.all

      financial_mutations.length.must_equal 1
      financial_mutations.first.id.must_equal "143274048181240838"
    end
  end
end
