require 'yaml'
require 'chronic_duration'

module Eyecare

  class ::Hash
    def symbolize_keys
      self.inject({}) do |h, (k, v)|
        v = v.symbolize_keys if v.respond_to?(:symbolize_keys)
        h.merge({ k.to_sym => v })
      end
    end
  end

  class Config
    DEFAULTS = {
      alert: {
        message: 'Look away',
        timeout: 20,
        interval: 20 * 60,
      },

      pid_file: File.expand_path(File.join('.eyecare', 'eyecare.pid'), '~')
    }

    def initialize(options = {})
      @options = DEFAULTS
      if options.respond_to?(:symbolize_keys)
        options = options.symbolize_keys
        options = parse_duration_values(options)
        @options.merge!(options)
      end
    end

    def self.load_from_file(filename)
      self.new(YAML.load_file(File.open(filename)))
    end

    def self.load_from_text(text)
      self.new(YAML.load(text))
    end

    def [](key)
      @options[key]
    end

    private
    def parse_duration_values(options)
      return options unless options.is_a?(Hash)
      if options[:alert].is_a?(Hash)
        [:interval, :timeout].each do |k|
          options[:alert][k] = ChronicDuration.parse(options[:alert][k]) if options[:alert][k].is_a?(String)
          options[:alert][k] = options[:alert][k].to_i
        end
      end
      options
    end
  end
end
