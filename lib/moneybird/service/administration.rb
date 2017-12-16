module Moneybird::Service
  class Administration
    include Moneybird::Traits::FindAll
    include Moneybird::Traits::Service

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def find(id)
      all.find{ |administration| administration.id.to_i == id }
    end

    private

    def resource_class
      Moneybird::Resource::Administration
    end

    def path
      '/administrations'
    end
  end
end