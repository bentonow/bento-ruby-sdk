module Bento
  class Subscribers
    class << self
      def find(email)
        endpoint = "/api/v1/fetch/subscribers"

        return "Subscriber"
      end

      def import
        return "Imported"
      end

      def create(email)
        return "Created subscriber"
      end
    end
  end
end