require 'action_controller/metal/renderers'
require 'action_controller/metal/responder'

module ActionController
  module Renderers
    attr_reader :amf_response

    add :amf do |amf, options|
      @amf_response = amf
      self.content_type ||= Mime::AMF
      self.response_body = " "
    end
  end
end

class ActionController::Responder
  def to_amf
    defined?(super) ? super : controller.render(:amf => resource.to_amf)
  end
end
