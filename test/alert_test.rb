require 'test_helper'
require 'eyecare/alert'

describe Eyecare::Alert do
  let(:config) do
    {
      message: 'Blink blink',
      timeout: 40,
      interval: 1800,
      beep: {
        player: 'fooplayer :file'
      }
    }
  end

  it 'defaults when no config' do
    alert = Eyecare::Alert.send(:new)
    alert.message.wont_be_empty
    alert.message.must_equal Eyecare::Alert::DEFAULT_MESSAGE
    alert.timeout.must_equal Eyecare::Alert::DEFAULT_TIMEOUT
    alert.beep.player.must_equal Eyecare::Alert::DEFAULT_BEEP_PLAYER
  end

  it 'correctly initialized from config hash' do
    alert = Eyecare::Alert.send(:new).init(config)

    alert.message.wont_be_empty
    alert.message.must_equal config[:message]
    alert.timeout.must_equal config[:timeout]
    alert.beep.player.must_equal config[:beep][:player]
  end
end
