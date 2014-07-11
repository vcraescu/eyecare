require 'libnotify'
require 'singleton'

module Eyecare
  class Alert
    include Singleton
    attr_accessor :message
    attr_accessor :timeout
    attr_accessor :start_beep_path
    attr_accessor :end_beep_path

    DEFAULT_MESSAGE = 'Look away'
    DEFAULT_TIMEOUT = 20

    def init(options = {})
      @message = options.fetch(:message, DEFAULT_MESSAGE)
      @timeout = options.fetch(:timeout, DEFAULT_TIMEOUT)
      @start_beep_path = options.fetch(:start_beep_file, File.join(Eyecare::AUDIOS_PATH, 'beep_start.wav'))
      @end_beep_path = options.fetch(:end_beep_file, File.join(Eyecare::AUDIOS_PATH, 'beep_end.wav'))
      self
    end

    def show
      beep_start
      notification.show!
      run_after(self.timeout) { beep_end }
    end

    private
    def initialize
      self.init
    end

    def icon_path
      File.join(Eyecare::IMAGES_PATH, 'eyecare.png')
    end

    def beep_start
      play_audio(start_beep_path)
    end

    def beep_end
      play_audio(end_beep_path)
    end

    def play_audio(filename)
      pid = spawn("aplay #{filename} > /dev/null 2>&1")
      Process.detach(pid)
    end

    def run_after(timeout, &block)
      sleep(timeout)
      yield
    end

    def notification
      Libnotify.new do |s|
        s.summary = 'Eye Care'
        s.body = self.message
        s.timeout = self.timeout
        s.urgency = :normal
        s.icon_path = icon_path
      end
    end
  end
end
