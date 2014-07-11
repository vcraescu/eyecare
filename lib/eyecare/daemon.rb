module Eyecare
  class Daemon
    attr_accessor :pid_file
    attr_accessor :out
    attr_accessor :err

    def initialize(options = {})
      options = Hash[pid_file: options] if options.is_a?(String)
      @pid_file = options[:pid_file]
    end

    def self.start(options = {}, &block)
      return false unless block_given?
      daemon = self.new(options)

      begin
        daemon.send(:cleanup) if daemon.stale_pid?
        if daemon.started?
          puts 'Already started'
          return false
        end

        print 'Starting...'
        Process.daemon(nil, true)
        daemon.send(:write_pid)

        trap('INT') { exit(0) }
        at_exit { daemon.send(:cleanup) }
      rescue StandardError => e
        puts 'Error: Start failed'
        puts e.message
      end

      puts "OK\n"
      yield
    end

    def self.stop(daemon)
      daemon = Daemon.new(pid_file: daemon) if daemon.is_a?(String)

      begin
        unless daemon.started?
          puts 'Not started or pid file is missing'
          return false
        end

        print 'Stopping...'
        pid = daemon.pid
        return false unless daemon.running?
        Process.kill('INT', pid)
        puts 'OK'
      rescue StandardError => e
        puts 'Error: Stop failed'
        puts e.inspect
      end
    end

    def started?
      File.file?(pid_file)
    end

    def stale_pid?
      !process_running?(read_pid) rescue false
    end

    def pid
      read_pid rescue 0
    end

    def running?
      process_running?(pid)
    end

    private 
    def process_running?(pid)
      return false unless pid && pid != 0
      system("kill -s 0 #{pid}")
    end

    def cleanup
      File.unlink(pid_file) rescue false
    end

    def read_pid
      pid = nil
      File.open(pid_file, 'r') do |f|
        pid = f.read
      end
      pid.to_i
    end

    def write_pid
      FileUtils.mkdir_p(File.dirname(pid_file))

      pid = Process.pid
      File.open(pid_file, 'w') do |f|
        f.write(pid)
      end
    end
  end
end
