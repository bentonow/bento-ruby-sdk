module Bento
  # Represents a response from the Bento API.
  # This class encapsulates the API response data and provides
  # methods to check the status of the operation (success or failure)
  # based on the number of successful and failed results.
  class Response
    attr_reader :results, :failed

    def initialize(response)
      @response = response
      @results = response['results'].to_i
      @failed = response['failed'].to_i
    end

    def success?
      failed.zero?
    end

    def failure?
      failed.positive?
    end
  end
end
