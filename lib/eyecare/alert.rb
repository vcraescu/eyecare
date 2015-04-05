require 'libnotify'
require 'singleton'
require 'eyecare/config'

module Eyecare
  # Alert
  class Alert
    include Singleton
    attr_accessor :message
    attr_accessor :timeout
    attr_accessor :beep
    attr_accessor :icon_path

    DEFAULT_MESSAGE     = Config::DEFAULTS[:alert][:message]
    DEFAULT_TIMEOUT     = Config::DEFAULTS[:alert][:timeout]
    DEFAULT_BEEP_START  = Config::DEFAULTS[:alert][:beep][:start]
    DEFAULT_BEEP_END    = Config::DEFAULTS[:alert][:beep][:end]
    DEFAULT_BEEP_PLAYER = Config::DEFAULTS[:alert][:beep][:player]
    DEFAULT_ICON_PATH   = Config::DEFAULTS[:alert][:icon]

    # Beep
    class Beep
      attr_accessor :start
      attr_accessor :end
      attr_accessor :player

      def initialize(options = {})
        @player = options[:player]
        @start = Eyecare::Audio.new(options[:start], options[:player])
        @end = Eyecare::Audio.new(options[:end], options[:player])
      end

      def play(name)
        send(name).play if [:start, :end].include?(name)
      end
    end

    def init(options = {})
      @message, @timeout, @icon_path =
        options.fetch(:message, DEFAULT_MESSAGE),
        options.fetch(:timeout, DEFAULT_TIMEOUT),
        options.fetch(:icon, DEFAULT_ICON_PATH)

      beep_start  = DEFAULT_BEEP_START
      beep_end    = DEFAULT_BEEP_END
      beep_player = DEFAULT_BEEP_PLAYER

      if options[:beep]
        beep_start = options[:beep][:start] if options[:beep][:start]
        beep_end = options[:beep][:end] if options[:beep][:end]
        beep_player = options[:beep][:player] if options[:beep][:player]
      end

      @beep = Beep.new(start: beep_start, end: beep_end, player: beep_player)
      self
    end

    def show
      beep.play(:start)
      notification.show!
      run_after(self.timeout) { beep.play(:end) }
    end

    private

    def initialize
      init
    end

    def run_after(timeout)
      sleep(timeout)
      yield
    end

    def notification
      Libnotify.new do |s|
        s.summary   = 'Eyecare'
        s.body      = message
        s.timeout   = timeout
        s.urgency   = :normal
        s.icon_path = icon_path
      end
    end
  end
end
