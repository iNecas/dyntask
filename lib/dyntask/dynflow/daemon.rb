module Dyntask
  class Dynflow::Daemon

    # load the Rails environment and initialize the executor and listener
    # in this thread.
    def run(rails_root = Dir.pwd)
      STDERR.puts("Starting Rails environment")
      rails_env_file = File.expand_path("./config/environment.rb", rails_root)
      unless File.exists?(rails_env_file)
        raise "#{rails_root} doesn't seem to be a rails root directory"
      end
      Dyntask.dynflow.executor!
      require rails_env_file
      STDERR.puts("Starting listener")
      daemon = ::Dynflow::Daemon.new(listener, world, lock_file)
      STDERR.puts("Everything ready")
      daemon.run
    end

    # run the executor as a daemon
    def run_background(command = "start", options = {})
      default_options = { rails_root: Dir.pwd,
                          process_name: 'dynflow_executor',
                          pid_dir: "#{Rails.root}/tmp/pids",
                          wait_attempts: 300,
                          wait_sleep: 1 }
      options = default_options.merge(options)
      begin
        require 'daemons'
      rescue LoadError
        raise "You need to add gem 'daemons' to your Gemfile if you wish to use it."
      end

      unless %w[start stop restart run].include?(command)
        raise "Command exptected to be 'start', 'stop', 'restart', 'run', was #{command.inspect}"
      end

      STDERR.puts("Dynflow Executor: #{command} in progress")

      Daemons.run_proc(options[:process_name],
                       :dir => options[:pid_dir],
                       :dir_mode => :normal,
                       :monitor => true,
                       :log_output => true,
                       :ARGV => [command]) do |*args|
        begin
          run(options[:rails_root])
        rescue => e
          STDERR.puts e.message
          Rails.logger.fatal e
          exit 1
        end
      end
      if command == "start" || command == "restart"
        STDERR.puts('Waiting for the executor to be ready...')
        options[:wait_attempts].times do |i|
          STDERR.print('.')
          if File.exists?(lock_file)
            STDERR.puts('executor started successfully')
            break
          else
            sleep options[:wait_sleep]
          end
        end
      end
    end

    protected

    def listener
       ::Dynflow::Listeners::Socket.new(world, socket_path)
    end

    def socket_path
      Dyntask.dynflow.config.remote_socket_path
    end

    def lock_file
      File.join(Rails.root, 'tmp', 'dynflow_executor.lock')
    end

    def world
       Dyntask.dynflow.world
    end


  end
end
