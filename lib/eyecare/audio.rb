module Eyecare
  class Audio
    attr_accessor :filename
    attr_accessor :player

    DEFAULT_PLAYER = 'aplay :file'

    def initialize(filename, player = nil)
      @filename = filename
      @player = player ? player : DEFAULT_PLAYER
    end

    def play
      return unless player
      pid = spawn(player_cmd + ' > /dev/null 2>&1')
      Process.detach(pid)
    end

    private
    def player_cmd
      return @player_cmd if @player_cmd
      @player_cmd = @player ? @player : DEFAULT_PLAYER
      @player_cmd = @player_cmd.gsub(/:filename/, ':file')
        .gsub(/:filepath/, ':file')
        .gsub(/:file_path/, ':file')
        .gsub(/:file/, filename)
    end
  end
end
