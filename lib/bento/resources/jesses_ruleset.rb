module Bento
  class Spam::JessesRuleset
    class << self
      def check(email, block_free_providers: false, wiggleroom: nil)
        payload = {
          email: email,
          block_free_providers: block_free_providers,
          wiggleroom: wiggleroom
        }

        response = client.post('api/v1/experimental/jesses_ruleset', payload.to_json)
        
        return response
      end

      # Example: Bento::Spam::JessesRuleset.reasons('test@bentonow.com')
      def reasons(email, **options)
        response = self.check(email, **options)

        return response['reasons']
      end

      private

      def client
        @client ||= Bento::Client.new
      end
    end
  end
end
