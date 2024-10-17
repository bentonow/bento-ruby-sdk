module Bento
  # Custom error class for handling Bento API errors.
  # This class encapsulates the HTTP response and provides
  # a formatted error message for easier debugging and error handling.
  class Error < StandardError
    attr_reader :response

    def initialize(response)
      @response = response
      super(formatted_error_message)
    end

    # Raises an instance of Bento::Error with the given response
    def self.raise_with_response(response)
      raise new(response)
    end

    private

    def formatted_error_message
      "HTTP #{response.status}: #{response.body}"
    end
  end
end
# Example usage:
# Bento::Error.raise_with_response(response)
