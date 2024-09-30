module Bento
  class Events
    class << self
      # Track an event
      # Usage: Bento::Events.track(email: 'user@example.com', type: '$completed_onboarding', fields: { first_name: 'Jesse', last_name: 'Pinkman' })
      def track(email:, type:, fields: {}, details: {})
        event = {
          email: email,
          type: type
        }
        event[:fields] = fields unless fields.empty?
        event[:details] = details unless details.empty?

        import([event])
      end

      # Batch track multiple events
      # Usage: Bento::Events.batch_track([{email: 'user1@example.com', event_name: 'Login'}, {email: 'user2@example.com', event_name: 'Purchase', properties: { amount: 29.99 }}])
      def import(events)
        payload = { events: events }.to_json
        client.post("api/v1/batch/events?#{URI.encode_www_form(default_params)}", payload)
      end

      private

      def client
        @client ||= Bento::Client.new
      end

      def default_params
        { site_uuid: Bento.config.site_uuid }
      end
    end
  end
end
