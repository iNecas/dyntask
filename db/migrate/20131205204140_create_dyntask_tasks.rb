class CreateDyntaskTasks < ActiveRecord::Migration
  def change
    create_table :dyntask_tasks, :id => false do |t|
      t.string :id, primary_key: true
      t.string :type
      t.string :action, index: true
      t.datetime :started_at, index: true
      t.datetime :ended_at, index: true
      t.string :state, index: true, null: false
      t.string :result, index: true, null: false
      t.decimal :progress, index: true, precision: 5, scale: 4
      t.string :external_id, index: true
    end
  end
end
