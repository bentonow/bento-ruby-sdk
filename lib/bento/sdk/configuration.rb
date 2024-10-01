module Bento
  class Configuration
    DEFAULT_CONFIGURATION = {
      site_uuid: nil,
      publishable_key: nil,
      secret_key: nil,
      dev_mode: false,
      sync_strategy: nil,
      sync_strategy_options: {},
      log_level: :warn,
    }.freeze

    def initialize(config_from_initialize = {})
      @config = default_config
        .merge(config_from_initialize)
        .merge(config_from_environment)
    end

    def self.inherit(parent, config_from_arguments)
      config = allocate
      config.instance_variable_set(:@parent, parent)
      config.instance_variable_set(:@config, config_from_arguments.to_hash)
      config
    end

    def merge(other_config)
      self.class.inherit(self, other_config)
    end

    def to_hash
      config
    end

    def to_h
      parent ? parent.to_h.merge(config) : to_hash
    end

    def ==(other)
      config == other.config && parent == other.parent
    end

  protected

    attr_reader :config, :parent

    def default_config
      DEFAULT_CONFIGURATION
    end

    def config_from_environment
      default_config.keys.each_with_object({}) do |key, config|
        value = ENV.fetch("BENTO_#{key.to_s.upcase}", nil)
        config[key] = value if value
      end
    end

    def key?(key)
      config.key?(key) || parent&.key?(key)
    end

    def [](key)
      config.key?(key) ? config[key] : parent && parent[key]
    end

    def []=(key, value)
      config[key] = value
    end

    def respond_to_missing?(name, include_private = false)
      name = name.to_s.sub(/=$/, '')
      key?(name.to_sym) || super
    end

    def method_missing(name, *args, &block)
      if respond_to_missing?(name)
        name = name.to_s
        method = name =~ /=$/ ? :[]= : :[]
        name = name.sub(/=$/, '').to_sym
        send(method, name, *args, &block)
      else
        super
      end
    end
  end
end
