module Bento
  module Validators
    module EventValidators
      ef validate_details(details)
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
