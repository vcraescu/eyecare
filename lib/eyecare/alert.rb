require 'libnotify'
require 'singleton'
require 'eyecare/config'

module Eyecare
  class Alert
    include Singleton
    attr_accessor :message
    attr_accessor :timeout
    attr_accessor :beep
    attr_accessor :icon_path

    DEFAULT_MESSAGE = Config::DEFAULTS[:alert][:message]
    DEFAULT_TIMEOUT = Config::DEFAULTS[:alert][:timeout]
    DEFAULT_BEEP_START = File.join(Config::AUDIOS_PATH, 'beep_start.wav')
    DEFAULT_BEEP_END = File.join(Config::AUDIOS_PATH, 'beep_end.wav')
    DEFAULT_ICON_PATH = Config::DEFAULTS[:alert][:icon]

    class Beep
      attr_accessor :start
      attr_accessor :end

      def initialize(options = {})
        @start = Eyecare::Audio.new(options[:start])
        @end = Eyecare::Audio.new(options[:end])
      end

      def play(name)
        self.send(name).play if [:start, :end].include?(name)
      end
    end

    def init(options = {})
      @message = options.fetch(:message, DEFAULT_MESSAGE)
      @timeout = options.fetch(:timeout, DEFAULT_TIMEOUT)
      @icon_path = options.fetch(:icon, DEFAULT_ICON_PATH)

      beep_start = DEFAULT_BEEP_START
      beep_end = DEFAULT_BEEP_END
      if options[:beep]
        beep_start = options[:beep][:start] if options[:beep][:start]
        beep_end = options[:beep][:end] if options[:beep][:end]
      end

      @beep = Beep.new(start: beep_start, end: beep_end)
      self
    end

    def show
      beep.play(:start)
      notification.show!
      run_after(self.timeout) { beep.play(:end) }
    end

    private
    def initialize
      self.init
    end

    def run_after(timeout, &block)
      sleep(timeout)
      yield
    end

    def notification
      Libnotify.new do |s|
        s.summary = 'Eyecare'
        s.body = self.message
        s.timeout = self.timeout
        s.urgency = :normal
        s.icon_path = icon_path
      end
    end
  end
end
