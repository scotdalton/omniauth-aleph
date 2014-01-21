module OmniAuth
  module Aleph
    class Adaptor
      class AlephError < StandardError; end
      class ConfigurationError < StandardError; end
      class AuthenticationError < StandardError; end
      class ConnectionError < StandardError; end

      # A list of required keys.
      REQUIRED_KEYS = [:host, :library, :sub_library]

      def self.validate(configuration={})
        message = []
        REQUIRED_KEYS.each do |key|
          message << key if(configuration[key].nil?)
        end
        raise ArgumentError.new(message.join(",") +" MUST be provided") unless message.empty?
      end

      def initialize(configuration={})
        self.class.validate(configuration)
        @configuration = configuration.dup
      end
    end
  end
end
