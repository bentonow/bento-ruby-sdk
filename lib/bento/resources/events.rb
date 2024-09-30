module Bento
  class Events
    class << self
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
        client.post("api/v1/batch/events?#{URI.encode_www_form(default_params)}", payload)
      end

      private

      def client
        @client ||= Bento::Client.new
      end

      def default_params
        { site_uuid: Bento.config.site_uuid }
      end

      def validate_email(email)
        raise ArgumentError, 'Email is required' if email.nil? || email.empty?
        raise ArgumentError, 'Invalid email format' unless email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      end

      def validate_type(type)
        raise ArgumentError, 'Type is required' if type.nil? || type.empty?
      end

      def validate_fields(fields)
        raise ArgumentError, 'Fields must be a hash' unless fields.is_a?(Hash)
      end

      def validate_details(details)
        raise ArgumentError, 'Details must be a hash' unless details.is_a?(Hash)
        validate_unique(details[:unique]) if details.key?(:unique)
        validate_value(details[:value]) if details.key?(:value)
        validate_cart(details[:cart]) if details.key?(:cart)
      end

      def validate_unique(unique)
        raise ArgumentError, 'Unique must be a hash' unless unique.is_a?(Hash)
        raise ArgumentError, 'Unique key is required' unless unique.key?(:key)
      end

      def validate_value(value)
        raise ArgumentError, 'Value must be a hash' unless value.is_a?(Hash)
        raise ArgumentError, 'Currency is required in value' unless value.key?(:currency)
        raise ArgumentError, 'Amount is required in value' unless value.key?(:amount)
      end

      def validate_cart(cart)
        raise ArgumentError, 'Cart must be a hash' unless cart.is_a?(Hash)
        validate_cart_items(cart[:items]) if cart.key?(:items)
      end

      def validate_cart_items(items)
        raise ArgumentError, 'Cart items must be an array' unless items.is_a?(Array)
        items.each do |item|
          raise ArgumentError, 'Cart item must be a hash' unless item.is_a?(Hash)
          raise ArgumentError, 'Product SKU is required in cart item' unless item.key?(:product_sku)
          raise ArgumentError, 'Product name is required in cart item' unless item.key?(:product_name)
          raise ArgumentError, 'Quantity is required in cart item' unless item.key?(:quantity)
        end
      end

      def validate_event(event)
        raise ArgumentError, 'Event must be a hash' unless event.is_a?(Hash)
        validate_email(event[:email])
        validate_type(event[:type])
        validate_fields(event[:fields]) if event.key?(:fields)
        validate_details(event[:details]) if event.key?(:details)
      end
    end
  end
end
