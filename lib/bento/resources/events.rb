module Bento
  class Events
    class << self
      include Bento::Validators::Base
      include Bento::Validators::EventValidators
      # Track an event
      # Usage examples:
      #
      # Basic event:
      # Bento::Events.track(email: 'test@test.com', type: '$completed_onboarding')
      #
      # Event with fields:
      # Bento::Events.track(
      #   email: 'test@test.com',
      #   type: '$completed_onboarding',
      #   fields: { first_name: 'Jesse', last_name: 'Pinkman' }
      # )
      #
      # Complex event with fields and details:
      # Bento::Events.track(
      #   email: 'test@test.com',
      #   type: '$purchase',
      #   fields: { first_name: 'Jesse' },
      #   details: {
      #     unique: { key: 'test123' },
      #     value: { currency: 'USD', amount: 8000 },
      #     cart: {
      #       items: [
      #         {
      #           product_sku: 'SKU123',
      #           product_name: 'Test',
      #           quantity: 100
      #         }
      #       ],
      #       abandoned_checkout_url: 'https://test.com'
      #     }
      #   }
      # )
      def track(email:, type:, fields: {}, details: {})
        validate_email(email)
        validate_type(type)
        validate_fields(fields)
        validate_details(details)

        event = {
          email: email,
          type: type
        }
        event[:fields] = fields unless fields.empty?
        event[:details] = details unless details.empty?

        import([event])
      end

      # Batch track multiple events
      # Usage: Bento::Events.import([{email: 'test@bentonow.com', type: 'Login'}, {email: 'test@bentonow.com', type: 'Purchase', fields: { first_name: 'Jesse', last_name: 'Hanley' }}])
      def import(events)
        raise ArgumentError, 'Events must be an array' unless events.is_a?(Array)
        events.each { |event| validate_event(event) }

        payload = { events: events }.to_json
        response = client.post("api/v1/batch/events?#{URI.encode_www_form(default_params)}", payload)
        Bento::Response.new(response)
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
