require 'dynflow/web_console'

Rails.application.routes.draw do
  namespace :dyntask do
    resources :tasks, :only => [:index, :show]

    namespace :api do
      resources :tasks, :only => [:show]
    end

    if Dyntask.dynflow_initialized?
      dynflow_console = Dynflow::WebConsole.setup do
        set(:world) { Dyntask.world }
      end

      mount dynflow_console => "/dynflow"
    end
  end
end
