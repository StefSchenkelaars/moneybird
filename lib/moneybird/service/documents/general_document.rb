module Moneybird::Service::Document
  class GeneralDocument
    include Moneybird::Traits::AdministrationService
    include Moneybird::Traits::Service
    include Moneybird::Traits::Find
    include Moneybird::Traits::FindAll
    include Moneybird::Traits::Save
    include Moneybird::Traits::Delete

    private

    def resource_class
      Moneybird::Resource::Documents::GeneralDocument
    end

    def path
      "#{administration_id}/documents/general_documents"
    end
  end
end