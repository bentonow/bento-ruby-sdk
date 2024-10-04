module Bento
  module Validators
    module EmailValidators
      def validate_author(author)
        raise ArgumentError, 'Author is required' if author.nil? || author.empty?
        # Additional validation can be implemented based on system requirements
      end
    end
  end
end
