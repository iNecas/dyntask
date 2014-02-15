module Dyntask

  # wrap the dynflow persistence to reflect the changes to execution plan
  # in the Task model. This is probably a temporary solution and
  # Dynflow will probably get more events-based API but it should be enought
  # for start, until the requiements on the API are clear enough.
  class Dynflow::Persistence < ::Dynflow::PersistenceAdapters::Sequel

    def save_execution_plan(execution_plan_id, value)
      super.tap do
        begin
          on_execution_plan_save(execution_plan_id, value)
        rescue => e
          Dyntask.dynflow.world.logger.error('Error on on_execution_plan_save event')
          Dyntask.dynflow.world.logger.error(e.message)
          Dyntask.dynflow.world.logger.error(e.backtrace.join("\n"))
        end
      end
    end

    def on_execution_plan_save(execution_plan_id, data)
      # We can load the data unless the execution plan was properly planned and saved
      # including its steps
      if data[:state] == :pending
        task = ::Dyntask::Task::DynflowTask.new
        task.update_from_dynflow(data, false)
      elsif data[:state] != :planning
        if task = ::Dyntask::Task::DynflowTask.find_by_external_id(execution_plan_id)
          task.update_from_dynflow(data, true)
        end
      end
    end

  end
end
