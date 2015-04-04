require 'test_helper'
require 'eyecare/audio'

describe Eyecare::Alert do
  it "player command is always valid" do
    audio = Eyecare::Audio.new('foo.wav', 'fooplayer :file')
    player_cmd = audio.send(:player_cmd)
    player_cmd.must_equal 'fooplayer foo.wav'

    audio = Eyecare::Audio.new('foo.wav', 'fooplayer :filename')
    player_cmd = audio.send(:player_cmd)
    player_cmd.must_equal 'fooplayer foo.wav'
  end
end
