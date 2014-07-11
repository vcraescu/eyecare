require 'yaml'

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
      @options.merge!(options.symbolize_keys) if options.respond_to?(:symbolize_keys)
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
  end
end
