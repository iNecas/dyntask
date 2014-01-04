module Dyntask
  class World < Dynflow::World
    def initialize
      db_config            = ActiveRecord::Base.configurations[Rails.env]
      db_config['adapter'] = 'postgres' if db_config['adapter'] == 'postgresql'
      db_config['adapter'] = 'sqlite'   if db_config['adapter'] == 'sqlite3'
      world_options        = { logger_adapter:      Dynflow::LoggerAdapters::Delegator.new(Rails.logger, Rails.logger),
                               executor_class:      Dynflow::Executors::Parallel, # TODO configurable Parallel or Remote
                               pool_size:           5,
                               persistence_adapter: Dyntask::DynflowPersistence.new(db_config),
                               transaction_adapter: Dynflow::TransactionAdapters::ActiveRecord.new }
      # we need to set the world before the rest initializes because
      # at the end of initialization, the world is expected to be set (the case of
      # resuming after error
      Dyntask.world = self
      super(world_options)
      world = self
      ActionDispatch::Reloader.to_prepare do
        Dyntask.eager_load!
        world.reload!
      end
      at_exit { world.terminate.wait }
      consistency_check
    end
  end
end
