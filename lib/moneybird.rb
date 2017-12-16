
require 'active_support'
require 'active_support/core_ext/object/json'
require 'active_support/core_ext/string/inflections'
require 'faraday'

require 'logger'
require 'uri'
require 'json'
require 'net/http'

module Moneybird
  module HttpError; end
  module Middleware; end
  module Service; end
  module Traits; end
end

require 'moneybird/resource'

Dir[File.join(File.dirname(__FILE__), 'moneybird', 'traits', '*.rb')].each  do |file|
  require file
end

Dir[File.join(File.dirname(__FILE__), 'moneybird', '**', '**.rb')].each  do |file|
  require file
end
