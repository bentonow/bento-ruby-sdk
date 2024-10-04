require "bento/analytics"
require "bento/core/client"
require "bento/core/error"
require "bento/core/response"
require "bento/core/version"
require "bento/core/validators/base"
require "bento/core/validators/event_validators"
require "bento/core/validators/email_validators"
require "bento/resources/subscribers"
require "bento/resources/events"
require "bento/resources/emails"

require "bento/sdk/configuration"

require 'forwardable'
require 'faraday'

module Bento
  class Error < StandardError; end

  class ArgumentError < Error; end

  class ConfigurationError < Error
    attr_reader :key

    def initialize(key)
      @key = key.to_sym

      super <<~CONFIG_ERROR_MESSAGE
        Missing config value for `#{key}`

        Please set a value for `#{key}` using an environment variable:

          BENTO_#{key.to_s.upcase}=your-value

        or via the `Bento.configure` method:

          Bento.configure do |config|
            config.#{key} = 'your-value'
          end
      CONFIG_ERROR_MESSAGE
    end
  end

  class << self
    extend Forwardable

    # User configurable options
    def_delegators :@config, :site_uuid, :site_uuid=
    def_delegators :@config, :publishable_key, :publishable_key=
    def_delegators :@config, :secret_key, :secret_key=
    def_delegators :@config, :log_level, :log_level=
    def_delegators :@config, :dev_mode, :dev_mode=

    def config
      @config ||= Bento::Configuration.new
    end

    def configure
      yield config
    end

    def reset!
      @config = nil
    end
  end
end
