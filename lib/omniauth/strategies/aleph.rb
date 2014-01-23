require 'omniauth'

module OmniAuth
  module Strategies
    class Aleph
      include OmniAuth::Strategy

      # Set defaults for options
      option :title, "Aleph Authentication"
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
        OmniAuth::Form.build(title: options[:title], url: callback_path) do |f|
          f.text_field 'Login', 'username'
          f.password_field 'Password', 'password'
        end.to_response
      end

      def callback_phase
        return fail!(:missing_credentials) if missing_credentials?
        adaptor = OmniAuth::Aleph::Adaptor.new(@options)
        @raw_info = adaptor.authenticate(username, password)
        super
      rescue OmniAuth::Aleph::Adaptor::AlephError => e
        fail!(e.message)
      end

      def username
        @username ||= request['username']
      end
      private :username

      def password
        @password ||= request['password']
      end
      private :password

      def missing_credentials?
        username.nil? || username.empty? || password.nil? || password.empty?
      end
      private :missing_credentials?
    end
  end
end
