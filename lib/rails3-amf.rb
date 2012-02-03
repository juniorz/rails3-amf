require 'rocketamf'

module Rails3AMF
end

require 'rails3-amf/serialization'
require 'rails3-amf/action_controller'
require 'rails3-amf/configuration'
require 'rails3-amf/request_parser'
require 'rails3-amf/request_processor'
require 'rails3-amf/railtie'

require 'action_dispatch' # Mime
Mime::Type.register("application/x-amf", :amf) unless Mime.const_defined?(:AMF)