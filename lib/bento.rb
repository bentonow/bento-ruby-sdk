require 'bento_v2/version'
require "bento_v2/client"
require 'bento_v2/configuration'

require 'logger'

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
    def config
      @config ||= Bento::Configuration.new
    end

    def logger
      @logger ||= begin
        logger = Logger.new($stdout)
        logger.progname = 'bento'
        logger.level = Logger.const_get(config.log_level.to_s.upcase)
        logger
      end
    end

    def configure
      yield config
    end

    def reset!
      @config = nil
    end

    attr_writer :logger
  end
end
