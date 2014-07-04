class Eyecare::Config
  attr_accessor :alert

  def initialize
    @alert = Alert.new
    yield self if block_given?
  end

  def self.load_from_file(filename)
    load_from_text(File.open(filename).read)
  end

  def self.load_from_text(text)
    config = self.new
    config.instance_eval do eval(text) end
    config
  end

  def to_hash
    { alert: alert.to_hash }
  end
end

class Eyecare::Config::Alert
  attr_accessor :message
  attr_accessor :timeout
  attr_accessor :interval

  def initialize
    @timeout = 20
    @interval = 20 * 60
  end

  def to_hash
    h = {}
    h[:message] = self.message if self.message
    h[:timeout] = self.timeout if self.timeout
    h[:interval] = self.interval if self.interval
    h
  end
end
