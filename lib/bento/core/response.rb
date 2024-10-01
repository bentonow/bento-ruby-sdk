module Bento
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