require 'test_helper'
require 'eyecare/config'

describe Eyecare::Config do
  it 'is initialize by a block' do
    config = Eyecare::Config.new do |c|
      c.alert.message = 'This is a test'  
      c.alert.timeout = 40
      c.alert.interval = 30 * 60
    end

    config.alert.message.wont_be_empty
    config.alert.timeout.must_equal 40
    config.alert.interval.must_equal 30 * 60
  end

  it 'is loaded from text' do
    text = %"
      alert.message = 'This is a test message'
      alert.timeout = 40
      alert.interval = 30 * 60
    "
    config = Eyecare::Config.load_from_text(text)
    config.alert.message.wont_be_empty
    config.alert.timeout.must_equal 40
    config.alert.interval.must_equal 30 * 60
  end

  it 'is loaded from file' do
    text = %"
      alert.message = 'This is a test message'
      alert.timeout = 60
      alert.interval = 40 * 60
    "
    require 'tempfile'
    f = Tempfile.new('config')
    f.write(text)
    f.close
  
    config = Eyecare::Config.load_from_file(f.path)
    f.unlink
    config.alert.message.wont_be_empty
    config.alert.timeout.must_equal 60
    config.alert.interval.must_equal 40 * 60
  end
end

