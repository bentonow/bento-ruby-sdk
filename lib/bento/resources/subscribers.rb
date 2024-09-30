module Bento
  class Subscribers
    class << self
      # Find or create a subscriber by email or uuid
      # Usage: Bento::Subscribers.find_or_create_by(email: 'test@bentonow.com')
      # or: Bento::Subscribers.find_or_create_by(uuid: 'subscriber-uuid')
      def find_or_create_by(email: nil, uuid: nil)
        params = default_params
        params[:email] = email if email
        params[:uuid] = uuid if uuid
        response = client.get("api/v1/fetch/subscribers?#{URI.encode_www_form(params)}")
        Subscriber.new(response['data'])
      end

      # Import or update subscribers in bulk
      # Usage: Bento::Subscribers.import([{email: 'user1@example.com', first_name: 'John'}, {email: 'user2@example.com', last_name: 'Doe'}])
      def import(subscribers)
        payload = { subscribers: subscribers }.to_json
        client.post("api/v1/batch/subscribers?#{URI.encode_www_form(default_params)}", payload)
      end

      # Run a command to change a subscriber's data
      # Usage: Bento::Subscribers.run_command(command: 'add_tag', email: 'test@bentonow.com', query: 'new_tag')
      def run_command(command:, email:, query: nil)
        payload = {
          command: [{
            command: command,
            email: email,
            query: query
          }]
        }.to_json
        
        response = client.post("api/v1/fetch/commands?#{URI.encode_www_form(default_params)}", payload)
        response
      end

      # Add a tag to a subscriber
      # Usage: Bento::Subscribers.add_tag(email: 'test@bentonow.com', tag: 'new_tag')
      def add_tag(email:, tag:)
        run_command(command: 'add_tag', email: email, query: tag)
      end

      # Add a tag to a subscriber via an event
      # Usage: Bento::Subscribers.add_tag_via_event(email: 'test@bentonow.com', tag: 'event_tag')
      def add_tag_via_event(email:, tag:)
        run_command(command: 'add_tag_via_event', email: email, query: tag)
      end

      # Remove a tag from a subscriber
      # Usage: Bento::Subscribers.remove_tag(email: 'test@bentonow.com', tag: 'old_tag')
      def remove_tag(email:, tag:)
        run_command(command: 'remove_tag', email: email, query: tag)
      end

      # Add a field to a subscriber
      # Usage: Bento::Subscribers.add_field(email: 'test@bentonow.com', key: 'company', value: 'Acme Inc')
      def add_field(email:, key:, value:)
        run_command(command: 'add_field', email: email, query: { key: key, value: value })
      end

      # Remove a field from a subscriber
      # Usage: Bento::Subscribers.remove_field(email: 'test@bentonow.com', field: 'company')
      def remove_field(email:, field:)
        run_command(command: 'remove_field', email: email, query: field)
      end

      # Subscribe a user
      # Usage: Bento::Subscribers.subscribe(email: 'test@bentonow.com')
      def subscribe(email:)
        run_command(command: 'subscribe', email: email)
      end

      # Unsubscribe a user
      # Usage: Bento::Subscribers.unsubscribe(email: 'test@bentonow.com')
      def unsubscribe(email:)
        run_command(command: 'unsubscribe', email: email)
      end

      # Change a subscriber's email
      # Usage: Bento::Subscribers.change_email(old_email: 'old@example.com', new_email: 'new@example.com')
      def change_email(old_email:, new_email:)
        run_command(command: 'change_email', email: old_email, query: new_email)
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

  class Subscriber
    attr_reader :id, :uuid, :email, :fields, :cached_tag_ids, :unsubscribed_at, :navigation_url

    def initialize(data)
      @id = data['id']
      attributes = data['attributes']
      @uuid = attributes['uuid']
      @email = attributes['email']
      @fields = attributes['fields']
      @cached_tag_ids = attributes['cached_tag_ids']
      @unsubscribed_at = attributes['unsubscribed_at']
      @navigation_url = attributes['navigation_url']
    end
  end
end