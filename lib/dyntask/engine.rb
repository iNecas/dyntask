require 'rabl'

module Dyntask
  class Engine < ::Rails::Engine
    engine_name "dyntask"

    initializer "dyntask.register_paths", :before => "dyntask.initialize_dynflow" do |app|
      actions_path = "#{Dyntask::Engine.root}/app/lib/actions"
      Dyntask.dynflow.config.eager_load_paths << actions_path
    end

    initializer "dyntask.load_app_instance_data" do |app|
      app.config.paths['db/migrate'].concat(Dyntask::Engine.paths['db/migrate'].existent)
    end

    initializer "dyntask.initialize_dynflow" do |app|
      Dyntask.dynflow.initialize!
    end
  end

  def self.table_name_prefix
    "dyntask_"
  end

end
