require 'test_helper'
require 'eyecare/alert'

describe Eyecare::Alert do
  let(:config) do
    { message: 'Blink blink', timeout: 40 }
  end

  it 'is defaulted is when no config' do
    alert = Eyecare::Alert.instance
    alert.message.wont_be_empty
    alert.message.must_equal Eyecare::Alert::DEFAULT_MESSAGE
    alert.timeout.must_equal Eyecare::Alert::DEFAULT_TIMEOUT
  end

  it 'is correctly initialized from config hash' do
    alert = Eyecare::Alert.instance.init(config)

    alert.message.wont_be_empty
    alert.message.must_equal config[:message]
    alert.timeout.must_equal config[:timeout]
  end
end
