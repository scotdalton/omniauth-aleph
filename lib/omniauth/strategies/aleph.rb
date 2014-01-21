require 'omniauth'

module OmniAuth
  module Strategies
    class Aleph
      include OmniAuth::Strategy

      option :title, "Aleph Authentication" #default title for authentication form

      def request_phase
        f = OmniAuth::Form.new(:title => (options[:title] || "Aleph Authentication"), :url => callback_path)
        f.text_field 'Login', 'username'
        f.password_field 'Password', 'password'
        f.button "Sign In"
        f.to_response
      end
    end
  end
end
