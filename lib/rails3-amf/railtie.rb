require 'rails/railtie'

module Rails3AMF
  class Railtie < Rails::Railtie
    config.rails3amf = Rails3AMF::Configuration.new

    config.before_initialize do
      Mime::Type.register("application/x-amf", :amf) unless Mime.const_defined?(:AMF)
    end

    initializer "rails3amf.middleware" do
      config.app_middleware.use Rails3AMF::RequestParser, config.rails3amf, Rails.logger
      config.app_middleware.use Rails3AMF::RequestProcessor, config.rails3amf, Rails.logger
    end
  end
end
