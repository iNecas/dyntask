module Dyntask
  class Task::DynflowTask < Task
    def execution_plan
      @execution_plan ||= Dyntask.world.persistence.load_execution_plan(external_id)
    end

    def input
      main_action.respond_to?(:task_input) && main_action.task_input
    end

    def output
      main_action.respond_to?(:task_output) && main_action.task_output
    end

    def humanized
      { action: main_action.respond_to?(:humanized_name) && main_action.humanized_name,
        input:  main_action.respond_to?(:humanized_input) && main_action.humanized_input,
        output: main_action.respond_to?(:humanized_output) && main_action.humanized_output }
    end

    def update_from_dynflow(data, planned)
      self.external_id  = data[:id]
      self.started_at  = data[:started_at]
      self.ended_at    = data[:ended_at]
      self.state       = data[:state].to_s
      self.result      = data[:result].to_s

      if planned
        # for now, this part needs to laod the execution_plan to
        # load extra data, there is place for optimization on Dynflow side
        # if needed (getting more keys into the data value)
        unless self.action
          self.action = main_action.action_class.name
        end
        update_progress
      end
      self.save!
    end

    def update_progress
      self.progress = execution_plan.progress
    end

    protected

    def main_action
      return @main_action if @main_action
      main_action_id = execution_plan.root_plan_step.action_id
      @main_action = execution_plan.actions.find { |action| action.id == main_action_id }
    end

  end
end
