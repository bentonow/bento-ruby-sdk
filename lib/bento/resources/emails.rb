module Bento
  class Emails
    class << self
      # Send an email that honors subscription status
      def send(to:, from:, subject:, html_body:, personalizations: {})
        validate_email(to)
        validate_author(from)

        payload = {
          to: to,
          from: from,
          subject: subject,
          html_body: html_body,
          personalizations: personalizations
        }

        send_bulk([payload])
      end

      # Send a transactional email that always sends, even if user is unsubscribed
      def send_transactional(to:, from:, subject:, html_body:, personalizations: {})
        validate_email(to)
        validate_author(from)

        payload = {
          to: to,
          from: from,
          subject: subject,
          html_body: html_body,
          personalizations: personalizations,
          transactional: true
        }

        send_bulk([payload])
      end

      def send_bulk(emails)
        raise ArgumentError, 'Emails must be an array' unless emails.is_a?(Array)
        emails.each { |email| validate_email(email) }

        payload = { emails: emails }.to_json
        response = client.post("api/v1/batch/emails?#{URI.encode_www_form(default_params)}", payload)
        Bento::Response.new(response)
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
      end

      def validate_author(author)
        raise ArgumentError, 'Author is required' if author.nil? || author.empty?
        # Additional validation can be implemented based on system requirements
      end
    end
  end
end
