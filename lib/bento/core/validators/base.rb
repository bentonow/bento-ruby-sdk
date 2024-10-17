module Bento
  module Validators
    module Base
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
    end
  end
end
