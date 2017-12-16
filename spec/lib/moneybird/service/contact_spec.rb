require "spec_helper"

describe Moneybird::Service::Contact do
  let(:client) { Moneybird::Client.new('bearer token') }
  let(:service) { Moneybird::Service::Contact.new(client, '123') }

  describe "#all" do
    before do
      stub_request(:get, 'https://moneybird.com/api/v2/123/contacts')
        .to_return(status: 200, body: fixture_response(:contacts))
    end

    it "returns list of contacts" do
      contacts = service.all

      contacts.length.must_equal 3
      contacts.first.company_name.must_equal "Foobar Holding B.V."
    end
  end

  describe "#build" do
    it "returns a non persisted contact" do
      contact = service.build(hash_response(:contacts).first)

      contact.company_name.must_equal "Foobar Holding B.V."
    end
  end

  describe "#create" do
    before do
      stub_request(:post, 'https://moneybird.com/api/v2/123/contacts')
        .to_return(status: 201, body: fixture_response(:contact))
    end

    it "creates a contact" do
      contact = service.create({company_name: 'ACME', firstname: 'Foo', lastname: 'Bar'})

      contact.id.must_equal hash_response(:contact)['id']
    end
  end

  describe "#update" do
    let(:id) { hash_response(:contact)['id'] }

    before do
      stub_request(:patch, "https://moneybird.com/api/v2/123/contacts/#{id}")
        .to_return(status: 201, body: fixture_response(:contact))
    end

    it "updates a contact" do
      contact = service.update({id: id, company_name: 'ACME', firstname: 'Foo', lastname: 'Bar'})

      contact.id.must_equal id
    end
  end

  describe "#save" do
    let(:id) { '1' }
    let(:attributes) { {id: id, company_name: 'ACME', firstname: 'Foo', lastname: 'Bar'} }

    it "creates when not persisted" do
      stub_request(:post, "https://moneybird.com/api/v2/123/contacts")
        .to_return(status: 201, body: fixture_response(:contact))
      attributes.delete(:id)

      resource = service.build(attributes)
      service.save(resource).must_equal resource
    end

    it "updates when persisted" do
      stub_request(:patch, "https://moneybird.com/api/v2/123/contacts/#{id}")
        .to_return(status: 200, body: fixture_response(:contact))

      resource = service.build(attributes)
      service.save(resource).must_equal resource
    end
  end

  describe "#delete" do
    let(:id) { '1' }
    let(:attributes) { {id: id, company_name: 'ACME', firstname: 'Foo', lastname: 'Bar'} }

    it "creates when not persisted" do
      stub_request(:delete, "https://moneybird.com/api/v2/123/contacts/#{id}")
        .to_return(status: 204, body: '')

      resource = service.build(attributes)
      service.delete(resource).must_equal true
    end
  end

  describe "#find" do
    let(:id) { hash_response(:contact)['id']}

    it "finds an existing record" do
      stub_request(:get, "https://moneybird.com/api/v2/123/contacts/#{id}")
        .to_return(status: 200, body: fixture_response(:contact))

      resource = service.find(id)
      resource.id.must_equal id
    end

    it "returns nil if record does not exist" do
      stub_request(:get, "https://moneybird.com/api/v2/123/contacts/#{id}")
        .to_return(status: 404, body: fixture_response(:error))

      assert_raises Moneybird::HttpError::NotFound do
        service.find(id)
      end
    end
  end

  describe "#find_by_customer_id" do
    let(:customer_id) { hash_response(:contact)['customer_id']}

    it "creates when not persisted" do
      stub_request(:get, "https://moneybird.com/api/v2/123/contacts/customer_id/#{customer_id}")
        .to_return(status: 200, body: fixture_response(:contact))

      resource = service.find_by_customer_id(customer_id)
      resource.customer_id.must_equal customer_id
    end

    it "returns nil if record does not exist" do
      stub_request(:get, "https://moneybird.com/api/v2/123/contacts/customer_id/#{customer_id}")
        .to_return(status: 404, body: fixture_response(:error))

      assert_raises Moneybird::HttpError::NotFound do
        service.find_by_customer_id(customer_id)
      end
    end
  end
end
