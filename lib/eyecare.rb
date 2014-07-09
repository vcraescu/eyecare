require "eyecare/version"
require 'eyecare/alert'
require 'eyecare/config'
require 'fileutils'
require 'eyecare/daemon'

module Eyecare
  ASSETS_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'eyecare', 'assets'))
  IMAGES_PATH = File.join(ASSETS_PATH, 'images')
  AUDIOS_PATH = File.join(ASSETS_PATH, 'audios')
  PID_FILE = File.expand_path(File.join('.eyecare', 'eyecare.pid'), '~')

  class << self
    def run
      Daemon.start(PID_FILE) do 
        while true
          sleep(config[:alert][:interval])
          alert.show
        end
      end
    end

    def stop
      Daemon.stop(PID_FILE)
    end

    def alert
      Alert.instance.init(config[:alert])
    end

    def config
      return @config if @config
      config_file = File.expand_path('~/.eyecare')
      begin
        @config = Config.load_from_file(config_file)
      rescue
      end

      @config ||= Config.new
    end
  end
end
