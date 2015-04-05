require 'yaml'
require 'chronic_duration'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/compact'
require 'active_support/core_ext/hash/deep_merge'
require 'eyecare'

module Eyecare
  class Config
    ASSETS_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'assets'))
    IMAGES_PATH = File.join(ASSETS_PATH, 'images')
    AUDIOS_PATH = File.join(ASSETS_PATH, 'audios')

    DEFAULTS = {
      alert: {
        message: 'Look away',
        timeout: 20,
        interval: 20 * 60,
        icon: File.join(IMAGES_PATH, 'eyecare.png'),
        beep: {
          player: 'aplay :file',
          start: File.join(AUDIOS_PATH, 'beep_start.wav'),
          end: File.join(AUDIOS_PATH, 'beep_end.wav')
        }
      },

      pid_file: File.expand_path(File.join('.eyecare', 'eyecare.pid'), '~')
    }

    attr_reader :options

    def initialize(options = {})
      @options = DEFAULTS
      return @options unless options.respond_to?(:deep_symbolize_keys)
      options = options.deep_symbolize_keys.deep_compact
      options = parse_duration_values(options)
      @options = @options.deep_merge(options)
    end

    def self.load_from_file(filename)
      new(YAML.load_file(File.open(filename)))
    end

    def self.load_from_text(text)
      new(YAML.load(text))
    end

    def [](key)
      @options[key]
    end

    private

    def parse_duration_values(options)
      return options unless options.is_a?(Hash) && options[:alert].is_a?(Hash)
      filter_duration_values(options[:alert], [:interval, :timeout])
      options
    end

    def filter_duration_value(value)
      return value.to_i unless value.is_a?(String)
      ChronicDuration.parse(value).to_i
    end

    def filter_duration_values(options, keys)
      keys.each do |k|
        next unless options[k]
        options[k] = filter_duration_value(options[k])
        options.delete(k) if options[k] == 0
      end
      options
    end
  end
end
