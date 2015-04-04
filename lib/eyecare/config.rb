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
          player: "aplay :file",
          start: File.join(AUDIOS_PATH, 'beep_start.wav'),
          end: File.join(AUDIOS_PATH, 'beep_end.wav')
        }
      },

      pid_file: File.expand_path(File.join('.eyecare', 'eyecare.pid'), '~')
    }

    attr_reader :options

    def initialize(options = {})
      @options = DEFAULTS
      if options.respond_to?(:deep_symbolize_keys)
        options = options.deep_symbolize_keys.deep_compact
        options = parse_duration_values(options)
        @options = @options.deep_merge(options)
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
          if options[:alert][k]
            options[:alert][k] = ChronicDuration.parse(options[:alert][k]) if options[:alert][k].is_a?(String)
            options[:alert][k] = options[:alert][k].to_i
            options[:alert].delete(k) if options[:alert][k] == 0
          end
        end
      end
      options
    end
  end
end
