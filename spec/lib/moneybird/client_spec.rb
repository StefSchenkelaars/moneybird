require "spec_helper"

describe Moneybird::Client do
  let(:client) { Moneybird::Client.new("bearer token") }

  it "sets a username" do
    client.bearer_token.must_equal 'bearer token'
  end

  describe '#http' do
    it 'returns a faraday connection object' do
      client.http.must_be_instance_of Faraday::Connection
    end
    it 'sets the token to the authorization header' do
      client.http.headers['Authorization'].must_equal 'Bearer bearer token'
    end
    it 'sets the url to the specified domain' do
      client.http.url_prefix.to_s.must_equal 'https://moneybird.com/'
    end
  end

  describe "#post" do
    it "posts and parses json" do
      stub_request(:post, 'https://moneybird.com/api/v2/path')
        .to_return(status: 200, body: { foo: 'bar' }.to_json)
      client.post('/path', 'body').must_equal('foo' => 'bar')
    end
  end

  describe '#get' do
    it "gets and parses json" do
      stub_request(:get, 'https://moneybird.com/api/v2/path')
        .to_return(status: 200, body: { foo: 'bar' }.to_json)
      client.get('/path').must_equal('foo' => 'bar')
    end
  end

  describe '#patch' do
    it "patches and parses json" do
      stub_request(:patch, 'https://moneybird.com/api/v2/path')
        .to_return(status: 200, body: { foo: 'bar' }.to_json)
      client.patch('/path', 'body').must_equal('foo' => 'bar')
    end
  end

  describe '#delete' do
    it "deletes and parses json" do
      stub_request(:delete, 'https://moneybird.com/api/v2/path')
        .to_return(status: 200, body: { foo: 'bar' }.to_json)
      client.delete('/path').must_equal('foo' => 'bar')
    end
  end

  describe '#get_all_pages' do
    it 'gets and parses all pages in json' do
      stub_request(:get, 'https://moneybird.com/api/v2/path')
        .to_return(
          status: 200,
          body: '[{"id":"1"}, {"id":"2"}]',
          headers: {
            'Link' => '<https://moneybird.com/api/v2/path?page=2>; rel="next"'
          }
        )
      stub_request(:get, 'https://moneybird.com/api/v2/path?page=2')
        .to_return(status: 200, body: '[{"id":"3"}, {"id":"4"}]')

      client.get_all_pages('/path').must_equal([{ 'id' => '1' }, { 'id' => '2' }, { 'id' => '3' }, { 'id' => '4' }])
    end
  end
end
