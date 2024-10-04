module Bento
  class Emails
    class << self
      include Bento::Validators::Base
      include Bento::Validators::EmailValidators
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
        emails.each { |email| validate_email(email[:to]); validate_email(email[:from]) }

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
    end
  end
end
