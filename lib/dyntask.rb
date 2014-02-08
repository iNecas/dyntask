require 'will_paginate'

require 'dyntask/version'
require 'dyntask/engine'
require 'dyntask/dynflow'

module Dyntask

  def self.dynflow
    @dynflow ||= Dyntask::Dynflow.new
  end

  def self.trigger(action, *args, &block)
    dynflow.world.trigger(action, *args, &block)
  end

  def self.async_task(action, *args, &block)
    run = trigger(action, *args, &block)
    Dyntask::Task::DynflowTask.find_by_external_id(run.id)
  end
end
