require "eyecare/version"
require 'eyecare/alert'
require 'eyecare/config'
require 'fileutils'
require 'eyecare/daemon'

module Eyecare
  ASSETS_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'eyecare', 'assets'))
  IMAGES_PATH = File.join(ASSETS_PATH, 'images')
  AUDIOS_PATH = File.join(ASSETS_PATH, 'audios')
  @config_path = File.expand_path('~/.eyecare/config.yml')

  class << self
    attr_reader :config_path

    def run
      Daemon.start(config[:pid_file]) do 
        while true
          sleep(config[:alert][:interval])
          alert.show
        end
      end
    end

    def stop
      Daemon.stop(config[:pid_file])
    end

    def alert
      Alert.instance.init(config[:alert])
    end

    def config
      return @config if @config

      config_file = File.expand_path(config_path)
      @config = Config.load_from_file(config_file) rescue Config.new
    end
  end
end
