require 'dynflow/web_console'

Rails.application.routes.draw do
  namespace :dyntask do
    resources :tasks, :only => [:index, :show]

    namespace :api do
      resources :tasks, :only => [:show]
    end

    if Dyntask.dynflow.config.web_console?
      require 'dynflow/web_console'
      mount Dyntask.dynflow.web_console => "/dynflow"
    end
  end
end
