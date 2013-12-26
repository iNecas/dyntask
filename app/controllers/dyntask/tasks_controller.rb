module Dyntask
  class TasksController < ::ApplicationController
    def show
      @task = Task.find(params[:id])
    end

    def index
      @tasks = Task.paginate(:page => params[:page])
    end

  end
end
