class RemoveForemanTasksProgress < ActiveRecord::Migration
  def change
    remove_column :dyntask_tasks, :progress
  end
end
