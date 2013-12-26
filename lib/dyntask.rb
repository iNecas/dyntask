require 'will_paginate'

require 'dyntask/version'
require 'dyntask/engine'
require 'dyntask/world'
require 'dyntask/dynflow_persistence'

module Dyntask

  def self.dynflow_initialized?
    !@world.nil?
  end

  def self.dynflow_initialize
    Dyntask::World.new
  end

  def self.world
    if @world
      return @world
    else
      raise "The Dynflow world was not initialized yet. "\
            "If your plugin uses it, make sure to call Dyntask.dynflow_initialize "\
            "in after_initialize block"
    end
  end

  def self.world=(world)
    @world = world
  end

  def self.trigger(action, *args, &block)
    world.trigger action, *args, &block
  end

  def self.async_task(action, *args, &block)
    run = trigger(action, *args, &block)
    Dyntask::Task::DynflowTask.find_by_external_id(run.id)
  end

  def self.eager_load_paths
    @eager_load_paths ||= []
  end

  def self.eager_load!
    eager_load_paths.each do |load_path|
      # todo: does the reloading work now?x
      Dir.glob("#{load_path}/**/*.rb").sort.each do |file|
        require_dependency file
      end
    end
  end
end
