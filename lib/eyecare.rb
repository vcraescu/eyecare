require "eyecare/version"
require 'eyecare/alert'
require 'eyecare/config'

module Eyecare
  ASSETS_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'eyecare', 'assets'))
  IMAGES_PATH = File.join(ASSETS_PATH, 'images')
  AUDIOS_PATH = File.join(ASSETS_PATH, 'audios')

  class << self
    def run!
      Process.daemon
      while true
        sleep(config.alert.interval)
        alert.show
      end
    end

    def run
      fork do
        sleep(config.alert.interval)
        alert.show
      end
    end

    private 
    def alert
      Alert.instance.init(config.alert.to_h)
    end

    def config
      return @config if @config
      config_file = File.expand_path('~/.eyecare')
      if File.file?(config_file)
        @config = Config.load_from_file(config_file)
      end
    end
  end

end
