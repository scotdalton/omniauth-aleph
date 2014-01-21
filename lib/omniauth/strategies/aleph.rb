require 'omniauth'

module OmniAuth
  module Strategies
    class Aleph
      include OmniAuth::Strategy

      # Set defaults for options
      option :title, "Aleph Authentication" #default title for authentication form
      option :port, 80

      def request_phase
        OmniAuth::Aleph::Adaptor.validate @options
        f = OmniAuth::Form.new(title: options[:title], url: callback_path)
        f.text_field 'Login', 'username'
        f.password_field 'Password', 'password'
        f.button "Sign In"
        f.to_response
      end
    end
  end
end
