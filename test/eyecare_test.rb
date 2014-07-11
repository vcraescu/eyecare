require 'test_helper'
require 'tempfile'

describe Eyecare do
  describe 'config' do
    it 'is default if config file is missing' do
      config = Eyecare.config
      config[:alert][:message].wont_be_empty
      config[:alert][:message].must_equal Eyecare::Config::DEFAULTS[:alert][:message]
      config[:alert][:timeout].must_equal Eyecare::Config::DEFAULTS[:alert][:timeout]
      config[:alert][:interval].must_equal Eyecare::Config::DEFAULTS[:alert][:interval]
      config[:pid_file].must_equal Eyecare::Config::DEFAULTS[:pid_file]
    end

    it 'is loaded from file if file exists' do
      config_yml = %"
        alert: 
          message: 'Yadayada'
          timeout: 10
          interval: 1000
        pid_file: '/path/to/pid/file.pid'
      "
      config_file = Tempfile.new('config')
      config_file.write(config_yml)
      config_file.close

      EyecareStub = Eyecare.dup
      EyecareStub.instance_eval do
        @config = nil
        @config_path = config_file.path
      end

      config = EyecareStub.config

      config[:alert][:message].wont_be_empty
      config[:alert][:message].must_equal 'Yadayada'
      config[:alert][:timeout].must_equal 10
      config[:alert][:interval].must_equal 1000
      config[:pid_file].must_equal '/path/to/pid/file.pid'

      config_file.unlink
    end
  end
end

