module Dyntask
  class Engine < ::Rails::Engine
    engine_name "dyntask"

    initializer "dyntask.register_paths" do |app|
      Dyntask.eager_load_paths.concat(%W[#{Dyntask::Engine.root}/app/lib/actions])
    end

    initializer "dyntask.load_app_instance_data" do |app|
      app.config.paths['db/migrate'].concat(Dyntask::Engine.paths['db/migrate'].existent)
    end


    initializer "dyntask.dynflow_initialize" do |app|
      Dyntask.dynflow_initialize
    end
  end

  def self.table_name_prefix
    "dyntask_"
  end

end
