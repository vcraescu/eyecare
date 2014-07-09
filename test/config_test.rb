require 'test_helper'
require 'eyecare/config'

describe Eyecare::Config do
  def assert_default(config)
    config[:alert][:message].wont_be_empty
    config[:alert][:message].must_equal Eyecare::Config::DEFAULTS[:alert][:message]
    config[:alert][:timeout].must_equal Eyecare::Config::DEFAULTS[:alert][:timeout]
    config[:alert][:interval].must_equal Eyecare::Config::DEFAULTS[:alert][:interval]
  end

  let(:config_text) do
    %"
      alert:
        message: 'This is a test message'
        timeout: 40
        interval: 1800
    "
  end

  it 'is loaded from text' do
    config = Eyecare::Config.load_from_text(config_text)
    config[:alert][:message].wont_be_empty
    config[:alert][:message].must_equal 'This is a test message'
    config[:alert][:timeout].must_equal 40
    config[:alert][:interval].must_equal 30 * 60
  end

  it 'is empty' do
    config = Eyecare::Config.load_from_text('')
    assert_default(config)
  end

  it 'is malformed' do
    config = Eyecare::Config.load_from_text('fdaf-fff:fsdafd')
    assert_default(config) 
  end

  it 'is loaded from file' do
    require 'tempfile'
    f = Tempfile.new('config')
    f.write(config_text)
    f.close
  
    config = Eyecare::Config.load_from_file(f.path)
    f.unlink
    config[:alert][:message].wont_be_empty
    config[:alert][:message].must_equal 'This is a test message'
    config[:alert][:timeout].must_equal 40
    config[:alert][:interval].must_equal 30 * 60
  end
end

