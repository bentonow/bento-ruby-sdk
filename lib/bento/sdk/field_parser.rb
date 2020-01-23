require 'digest'

module Bento
  class Analytics
    class FieldParser
      class << self
        include Bento::Analytics::Utils

        def parse_for_track(fields, write_key)
          common = parse_common_fields(fields)

          event = fields[:event]

          custom_fields = fields[:custom_fields] || {}
          details = fields[:details] || {}
          identity = fields[:identity] || {}
          page = fields[:page] || {}

          check_presence!(event, "event")
          check_is_hash!(details, "details")
          check_is_hash!(page, "page")
          check_is_hash!(identity, "identity")
          check_is_hash!(custom_fields, "custom_fields")

          isoify_dates! details

          final_event = {
            id: SecureRandom.hex(10),
            site: write_key,
            identity: identity,
            visit: Digest::SHA2.hexdigest(Time.now.strftime("%B %e, %Y") + identity.to_s + write_key),
            visitor: Digest::SHA2.hexdigest("api" + identity.to_s + write_key),
            type: event.to_s,
            date: Time.now,
            browser: {
              "user_agent" => "Bento/API (Rails)",
            },
            page: page,
            details: details,
            fields: custom_fields,
          }

          common = common.merge(final_event)
          common
        end

        private

        def parse_common_fields(fields)
          timestamp = fields[:date] || Time.new
          message_id = fields[:message_id].to_s if fields[:message_id]
          page = fields[:page] || {}
          context = {}

          check_user_id! fields

          check_timestamp! timestamp

          add_context! context

          parsed = {
            page: page,
            date: datetime_in_iso8601(timestamp),
            identity: {email: nil},
          }

          parsed[:identity][:email] = fields[:identity][:email] if fields[:identity][:email]
          parsed[:visitor] = fields[:visitor_id] if fields[:visitor_id]

          parsed
        end

        def check_user_id!(fields)
          unless fields[:identity] || fields[:visitor]
            raise ArgumentError, "Must supply either user_id or anonymous_id"
          end
        end

        def check_timestamp!(timestamp)
          raise ArgumentError, "Timestamp must be a Time" unless timestamp.is_a? Time
        end

        def add_context!(context)
          context[:library] = {name: "bento-ruby"}
        end

        # private: Ensures that a string is non-empty
        #
        # obj    - String|Number that must be non-blank
        # name   - Name of the validated value
        def check_presence!(obj, name)
          if obj.nil? || (obj.is_a?(String) && obj.empty?)
            raise ArgumentError, "#{name} must be given"
          end
        end

        def check_is_hash!(obj, name)
          raise ArgumentError, "#{name} must be a Hash" unless obj.is_a? Hash
        end
      end
    end
  end
end
