require 'uuidtools'

module Dyntask
  class Task < ActiveRecord::Base

    self.primary_key = :id
    before_create :generate_id

    has_many :locks

    # in fact, the task has only one owner but Rails don't let you to
    # specify has_one relation though has_many relation
    has_many :owners,
             through: :locks, source: :resource,
             conditions: -> { where(:'dyntask_locks.name' => Lock::OWNER_LOCK_NAME) }

    scope :active, -> {  where('state != ?', :stopped) }

    def input
      {}
    end

    def output
      {}
    end

    def humanized
      { action: action,
        input:  "",
        output: "" }
    end

    def owner
      self.owners.first
    end

    def self.search_by_generic_resource(key, operator, value)
      key_name = self.connection.quote_column_name(key.sub(/^.*\./,''))
      condition = sanitize_sql_for_conditions(["dyntask_locks.#{key_name} #{operator} ?", value])

      return {:conditions => condition, :joins => :locks }
    end

    def self.search_by_owner(key, operator, value)
      key_name = self.connection.quote_column_name(key.sub(/^.*\./,''))
      joins = <<-JOINS
      INNER JOIN dyntask_locks AS dyntask_locks_owner
                 ON (dyntask_locks_owner.task_id = dyntask_tasks.id AND
                     dyntask_locks_owner.resource_type = 'User' AND
                     dyntask_locks_owner.name = '#{Lock::OWNER_LOCK_NAME}')
      INNER JOIN users
                 ON (users.id = dyntask_locks_owner.resource_id)
      JOINS
      condition = sanitize_sql_for_conditions(["users.#{key_name} #{operator} ?", value])
      return {:conditions => condition, :joins => joins }
    end

    protected

    def generate_id
      self.id ||= UUIDTools::UUID.random_create.to_s
    end
  end
end
