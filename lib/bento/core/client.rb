module Bento
  class Client
    def get(endpoint)
      conn.get(endpoint)
    end

    def post(endpoint, payload = nil)
      conn.post(endpoint, payload)
    end

    private

    def authorization
      @authorization ||= "Basic #{Bento.publishable_key}:#{Bento.secret_key}"
    end

    def conn
      conn = Faraday.new(
        url: 'https://app.bentonow.com',
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'User-Agent' => 'bento-ruby',
          'Authorization' => authorization
        }
      )
    end
  end
end