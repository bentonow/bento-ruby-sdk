module Bento
  class Client
    def get(endpoint)
      response = conn.get(endpoint)
      parse_response(response)
    end

    def post(endpoint, payload = nil)
      response = conn.post(endpoint, payload)
      parse_response(response)
    end

    private

    def parse_response(response)
      if response.success?
        JSON.parse(response.body)
      else
        raise Bento::Error.from_response(response)
      end
    end

    private

    def authorization
      @authorization ||= "Basic #{Base64.strict_encode64("#{Bento.publishable_key}:#{Bento.secret_key}")}"
    end

    def conn
      conn = Faraday.new(
        url: dev_mode? ? 'http://localhost:3000' : 'https://app.bentonow.com',
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'User-Agent' => 'bento-ruby',
          'Authorization' => authorization
        }
      )
    end

    def dev_mode?
      Bento.dev_mode || false
    end
  end
end