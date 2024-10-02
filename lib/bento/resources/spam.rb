module Bento
  class Spam
    class << self
      def valid?(email)
        payload = {
          email: email
        }

        response = client.post('api/v1/experimental/validation', payload.to_json)
        
        return response['valid']
      end

      # Example: Bento::Spam.risky?('test@bentonow.com')
      def risky?(email)
        !self.valid?(email)
      end

      private

      def client
        @client ||= Bento::Client.new
      end
    end
  end
end
