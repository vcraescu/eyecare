require 'test_helper'
require 'eyecare/config'

describe Eyecare::Config do
  def assert_default(config)
    config[:alert][:message].wont_be_empty
    config[:alert][:message].must_equal Eyecare::Config::DEFAULTS[:alert][:message]
    config[:alert][:timeout].must_equal Eyecare::Config::DEFAULTS[:alert][:timeout]
    config[:alert][:interval].must_equal Eyecare::Config::DEFAULTS[:alert][:interval]
    config[:alert][:beep][:start].must_equal Eyecare::Config::DEFAULTS[:alert][:beep][:start]
    config[:alert][:beep][:end].must_equal Eyecare::Config::DEFAULTS[:alert][:beep][:end]
    config[:pid_file].must_equal Eyecare::Config::DEFAULTS[:pid_file]
  end

  let(:config_text) do
    %"
      alert:
        message: 'This is a test message'
        timeout: 40
        interval: 1800
        beep:
          start: /path/to/beep/start.wav
          end: /path/to/beep/end.wav
      pid_file: /path/to/my/pid/file.pid
    "
  end

  let(:friendly_config_text) do
    %"
      alert:
        message: 'This is a test message'
        timeout: 30 seconds
        interval: 50 minutes
        beep:
          start: /path/to/beep/start.wav
          end: /path/to/beep/end.wav
      pid_file: /path/to/my/pid/file.pid
    "
  end

  let(:friendly_config_text_wrong) do
    %"
      alert:
        message: 'This is a test message'
        timeout: test
        interval: blah
        beep:
          start: /path/to/beep/start.wav
          end: /path/to/beep/end.wav
      pid_file: /path/to/my/pid/file.pid
    "
  end

  let(:config_text_missing_values) do
    %"
      alert:
        message: 'This is a test message'
        timeout:
        interval:
        beep:
          start: /path/to/beep/start.wav
          end: /path/to/beep/end.wav
      pid_file: /path/to/my/pid/file.pid
    "
  end

  it 'is loaded from text' do
    config = Eyecare::Config.load_from_text(config_text)
    config[:alert][:message].wont_be_empty
    config[:alert][:message].must_equal 'This is a test message'
    config[:alert][:timeout].must_equal 40
    config[:alert][:interval].must_equal 30 * 60
    config[:alert][:beep][:start].must_equal '/path/to/beep/start.wav'
    config[:alert][:beep][:end].must_equal '/path/to/beep/end.wav'
    config[:pid_file].must_equal '/path/to/my/pid/file.pid'
  end

  it 'is empty' do
    config = Eyecare::Config.load_from_text('')
    assert_default(config)
  end

  it 'is malformed' do
    config = Eyecare::Config.load_from_text(YAML.load('fdaf-fff:fsdafd'))
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
    config[:alert][:beep][:start].must_equal '/path/to/beep/start.wav'
    config[:alert][:beep][:end].must_equal '/path/to/beep/end.wav'
    config[:pid_file].must_equal '/path/to/my/pid/file.pid'
  end

  it 'friendly config is parsed correctly' do
    config = Eyecare::Config.load_from_text(friendly_config_text)
    config[:alert][:message].must_equal 'This is a test message'
    config[:alert][:interval].must_equal 60 * 50
    config[:alert][:timeout].must_equal 30
    config[:alert][:beep][:start].must_equal '/path/to/beep/start.wav'
    config[:alert][:beep][:end].must_equal '/path/to/beep/end.wav'
  end

  it 'friendly config is has wrong values' do
    config = Eyecare::Config.load_from_text(friendly_config_text_wrong)
    config[:alert][:message].must_equal 'This is a test message'
    config[:alert][:interval].must_equal Eyecare::Config::DEFAULTS[:alert][:interval]
    config[:alert][:timeout].must_equal Eyecare::Config::DEFAULTS[:alert][:timeout]
  end

  it 'has missing values' do
    config = Eyecare::Config.load_from_text(config_text_missing_values)
    config[:alert][:message].must_equal 'This is a test message'
    config[:alert][:interval].must_equal Eyecare::Config::DEFAULTS[:alert][:interval]
    config[:alert][:timeout].must_equal Eyecare::Config::DEFAULTS[:alert][:timeout]
  end
end
