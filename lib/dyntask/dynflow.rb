require 'dynflow'

module Dyntask
  # Class for configuring and preparing the Dynflow runtime environment.
  class Dynflow
    require 'dyntask/dynflow/configuration'
    require 'dyntask/dynflow/persistence'
    require 'dyntask/dynflow/daemon'

    def initialize
      @required = false
    end

    def config
      @config ||= Dyntask::Dynflow::Configuration.new
    end

    def initialized?
      !@world.nil?
    end

    def initialize!
      return @world if @world

      eager_load_actions!
      self.tap do |dynflow|
        ActionDispatch::Reloader.to_prepare { dynflow.eager_load_actions! }
      end

      if config.lazy_initialization && defined? PhusionPassenger
        config.dynflow_logger.warn("Dyntask: lazy loading with PhusionPassenger might lead to unexpected results")
      end
      config.initialize_world.tap do |world|
        @world = world

        unless config.remote?
          at_exit { world.terminate.wait }

          # for now, we can check the consistency only when there
          # is no remote executor. We should be able to check the consistency
          # every time the new world is created when there is a register
          # of executors
          world.consistency_check
        end
      end
    end

    # Mark that the process is executor. This prevents the remote setting from
    # applying. Needs to be set up before the world is being initialized
    def executor!
      @executor = true
    end

    def executor?
      @executor
    end

    def reinitialize!
      @world = nil
      self.initialize!
    end

    def world
      return @world if @world

      initialize! if config.lazy_initialization
      unless @world
        raise 'The Dynflow world was not initialized yet. '\
              'If your plugin uses it, make sure to call Dyntask.dynflow.require! '\
              'in some initializer'
      end

      return @world
    end

    def web_console
      ::Dynflow::WebConsole.setup do
        set(:world) { Dyntask.dynflow.world }
      end
    end

    def eager_load_actions!
      config.eager_load_paths.each do |load_path|
        Dir.glob("#{load_path}/**/*.rb").sort.each do |file|
          require_dependency file
        end
      end
      @world.reload! if @world
    end
  end
end
