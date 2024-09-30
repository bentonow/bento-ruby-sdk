module Bento
    class Error < StandardError
      attr_reader :response
  
      def self.from_response(response)
        new("HTTP #{response.status}: #{response.body}")
      end
  
      def initialize(message)
        super(message)
      end
    end
  end