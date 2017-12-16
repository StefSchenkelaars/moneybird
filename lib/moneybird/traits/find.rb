module Moneybird
  module Traits
    module Find
      def find(id)
        build client.get("#{path}/#{id}")
      end
    end
  end
end