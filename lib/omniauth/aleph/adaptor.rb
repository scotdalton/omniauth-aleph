module OmniAuth
  module Aleph
    require 'faraday'
    require 'ox'
    require 'multi_xml'
    class Adaptor
      class AlephError < StandardError; end

      # List of keys, all are required.
      KEYS = [:scheme, :host, :port, :library, :sub_library]

      def self.validate(configuration={})
        message = []
        KEYS.each do |key|
          message << key if(configuration[key].nil?)
        end
        unless message.empty?
          raise ArgumentError.new(message.join(",") +" MUST be provided")
        end
      end

      def initialize(configuration={})
        self.class.validate(configuration)
        @configuration = configuration.dup
        @logger = @configuration.delete(:logger)
        KEYS.each do |key|
          instance_variable_set("@#{key}", @configuration[key])
        end
      end

      def authenticate(username, password)
        url = bor_auth_url + "&bor_id=#{username}&verification=#{password}"
        response = Faraday.get url
        # If we get a successful response AND we are looking at XML and we have a body
        if response.status == 200 && response.headers["content-type"] == 'text/xml' && response.body
          json = MultiXml.parse(response.body)
          if json["bor_auth"] && (error = json["bor_auth"]["error"]).nil?
            return json
          elsif json["bor_auth"].nil?
            raise AlephError.new("Aleph responded, but it's not a response I understand.")
          else
            raise AlephError.new(error)
          end
        else
          raise AlephError.new("Aleph response:\n\t #{@response.inspect}.")
        end
      rescue Faraday::ConnectionFailed => e
        raise AlephError.new("Couldn't connect to Aleph.")
      end

      def bor_auth_url
        @bor_auth_url ||= "#{@scheme}://#{@host}:#{@port}"+
          "/X?op=bor-auth&library=#{@library}&sub_library=#{@sub_library}"
      end
      private :bor_auth_url
    end
  end
end
