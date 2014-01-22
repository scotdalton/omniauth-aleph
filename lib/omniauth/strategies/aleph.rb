require 'omniauth'

module OmniAuth
  module Strategies
    class Aleph
      include OmniAuth::Strategy

      # Set defaults for options
      option :title, "Aleph Authentication" #default title for authentication form
      option :scheme, 'http'
      option :port, 80

      uid { @raw_info["bor_auth"]["z303"]["z303_id"] }

      info do
        {
          'name' => @raw_info["bor_auth"]["z303"]["z303_name"],
          'nickname' => @raw_info["bor_auth"]["z303"]["z303_id"],
          'email' => @raw_info["bor_auth"]["z304"]["z304_email_address"],
          'phone' => @raw_info["bor_auth"]["z304"]["z304_telephone"]
        }
      end

      extra do
        (skip_info?) ? {} : { 'raw_info' => @raw_info }
      end

      def request_phase
        OmniAuth::Aleph::Adaptor.validate @options
        f = OmniAuth::Form.new(title: options[:title], url: callback_path)
        f.text_field 'Login', 'username'
        f.password_field 'Password', 'password'
        f.button "Sign In"
        f.to_response
      end

      def callback_phase
        return fail!(:missing_credentials) if missing_credentials?
        adaptor = OmniAuth::Aleph::Adaptor.new(@options)
        @raw_info = adaptor.authenticate(request['username'], request['password'])
      rescue OmniAuth::Aleph::Adaptor::AlephError => e
        fail!(e.message)
      end

      def missing_credentials?
        request['username'].nil? || request['username'].empty? || 
          request['password'].nil? || request['password'].empty?
      end
      private :missing_credentials?
    end
  end
end
