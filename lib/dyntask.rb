require 'will_paginate'

require 'dyntask/version'
require 'dyntask/task_error'
require 'dyntask/engine'
require 'dyntask/dynflow'

module Dyntask

  extend Algebrick::Matching

  def self.dynflow
    @dynflow ||= Dyntask::Dynflow.new
  end

  def self.trigger(action, *args, &block)
    dynflow.world.trigger(action, *args, &block)
  end

  def self.trigger_task(async, action, *args, &block)
    match trigger(action, *args, &block),
          (on ::Dynflow::World::PlaningFailed.(error: ~any) |
                  ::Dynflow::World::ExecutionFailed.(error: ~any) do |error|
            raise error
          end),
          (on ::Dynflow::World::Triggered.(execution_plan_id: ~any, future: ~any) do |id, finished|
            finished.wait if async == false
            Dyntask::Task::DynflowTask.find_by_external_id!(id)
          end)
  end

  def self.async_task(action, *args, &block)
    trigger_task(true, action, *args, &block)
  end

  def self.sync_task(action, *args, &block)
    trigger_task(false, action, *args, &block).tap do |task|
      raise TaskError.new(task) if task.execution_plan.error?
    end
  end
end
