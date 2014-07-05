require 'libnotify'
require 'singleton'

module Eyecare
  class Alert
    include Singleton
    attr_accessor :message
    attr_accessor :timeout

    DEFAULT_MESSAGE = 'Look away'
    DEFAULT_TIMEOUT = 20

    def init(options = {})
      @message = options.fetch(:message, DEFAULT_MESSAGE)
      @timeout = options.fetch(:timeout, DEFAULT_TIMEOUT)
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
      play_audio('beep_start.wav')
    end

    def beep_end
      play_audio('beep_end.wav')
    end

    def play_audio(filename)
      audio_path = File.join(Eyecare::AUDIOS_PATH, filename)
      pid = spawn("aplay #{audio_path} > /dev/null 2>&1")
      Process.detach(pid)
    end

    def run_after(timeout, &block)
      pid = fork do
        sleep(timeout)
        yield
      end
      Process.detach(pid)
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

#puts Eyecare::ASSETS_PATH
#Eyecare::Alert.new.show
