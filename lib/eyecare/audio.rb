module Eyecare
  class Audio
    attr_accessor :filename
    def initialize(filename)
      @filename = filename
    end

    def play
      pid = spawn("aplay #{filename} > /dev/null 2>&1")
      Process.detach(pid)
    end
  end
end
