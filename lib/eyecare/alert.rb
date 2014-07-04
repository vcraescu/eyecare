require 'libnotify'
require 'beep'

class Eyecare::Alert
  attr_accessor :message
  attr_accessor :timeout

  DEFAULT_MESSAGE = 'Look away'
  DEFAULT_TIMEOUT = 20

  def initialize(options = {})
    @message = options.fetch(:message, DEFAULT_MESSAGE)
    @timeout = options.fetch(:timeout, DEFAULT_TIMEOUT)
  end

  def show
    beep
    notification.show!
  end

  private
  def icon_path
    File.join(Eyecare::IMAGES_PATH, 'eyecare.png')
  end

  def beep
    audio_path = File.join(Eyecare::AUDIOS_PATH, 'beep.mp3')
    pid = spawn("mplayer #{audio_path} > /dev/null 2>1")
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
