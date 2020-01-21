require 'bento/sdk/version'
require 'bento/sdk/defaults'
require 'bento/sdk/utils'
require 'bento/sdk/field_parser'
require 'bento/sdk/client'
require 'bento/sdk/worker'
require 'bento/sdk/transport'
require 'bento/sdk/response'
require 'bento/sdk/logging'

module Bento

  class << self
    attr_writer :write_key
  end

  def self.configure(&block)
    yield self
  end

  class Analytics
    # Initializes a new instance of {Bento::Analytics::Client}, to which all
    # method calls are proxied.
    #
    # @param options includes options that are passed down to
    #   {Bento::Analytics::Client#initialize}
    # @option options [Boolean] :stub (false) If true, requests don't hit the
    #   server and are stubbed to be successful.
    def initialize(options = {})
      Transport.stub = options[:stub] if options.has_key?(:stub)
      @client = Bento::Analytics::Client.new options
    end

    def method_missing(message, *args, &block)
      if @client.respond_to? message
        @client.send message, *args, &block
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @client.respond_to?(method_name) || super
    end

    include Logging
  end
end
