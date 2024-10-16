module Bento
  # Client class for interacting with the Bento API.
  # This class provides methods for making HTTP GET and POST requests to the API,
  # handles authentication, connection errors, and response parsing.
  # It also supports a development mode for local testing.
  class Client
    def get(endpoint)
      handle_connection_errors { parse_response(conn.get(endpoint)) }
    end

    def post(endpoint, payload = nil)
      handle_connection_errors { parse_response(conn.post(endpoint, payload)) }
    end

    private

    def parse_response(response)
      if response.success?
        JSON.parse(response.body)
      else
        Bento::Error.raise_with_response(response)
      end
    end

    def authorization
      @authorization ||= "Basic #{Base64.strict_encode64("#{Bento.publishable_key}:#{Bento.secret_key}")}"
    end

    def conn
      Faraday.new(
        url: Bento.dev_mode ? 'http://localhost:3000' : 'https://app.bentonow.com',
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'User-Agent' => 'bento-rails-' + Bento.site_uuid,
          'Authorization' => authorization
        }
      )
    end

    def handle_connection_errors
      yield
    rescue Faraday::ConnectionFailed => exception
      raise Bento::ConnectionError, "Failed to connect to the server: #{exception.message}"
    end
  end
end
