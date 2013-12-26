module Actions
  module Helpers
    module Lock
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def generate_phase(phase_module)
          super.tap do |phase_class|
            if phase_module == Dynflow::Action::PlanPhase
              phase_class.send(:include, PlanMethods)
            end
          end
        end

      end

      module PlanMethods

        def task
          ::Dyntask::Task::DynflowTask.find_by_external_id!(execution_plan_id)
        end

        # @see Lock.exclusive!
        def exclusive_lock!(resource)
          ::Dyntask::Lock.exclusive!(resource, task.id)
        end

        # @see Lock.lock!
        def lock!(resource, *lock_names)
          ::Dyntask::Lock.lock!(resource, task.id, *lock_names.flatten)
        end

        # @see Lock.link!
        def link!(resource)
          ::Dyntask::Lock.link!(resource, task.id)
        end
      end
    end
  end
end
