module Moneybird
  module Traits
    module Service
      def build(attributes)
        resource_class.build attributes.merge(client: client)
      end
    end
  end
end