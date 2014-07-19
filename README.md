# Eyecare

Reminds you to look away to avoid computer eye strain.
It is recommended to look away from your screen for 20 seconds every 20 minutes.
This might only work on Ubuntu!

## Installation

    $ gem install eyecare

## Usage

    $ eyecare start
    $ eyecare stop

The app will run as a daemon and pid file will be saved into ~/.eyecare/eyecare.pid
To see how much time left till next notification:
    
    $ ps aux | grep Eyecare


Create a config file ~/.eyecare/config.yml
    
Config options are:

    alert:
      message: 'Yor message here'
      timeout: 20 seconds
      interval: 20 minutes
      icon: /path/to/icon.png
      beep:
        start: /path/to/audio.wav
        end: /path/to/audio.wav
