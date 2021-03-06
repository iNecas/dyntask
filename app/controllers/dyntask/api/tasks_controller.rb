#
# Copyright 2013 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

module Dyntask
  module Api
    class TasksController < ApplicationController

      before_filter :find_task, :only => [:show]

      def show
        render 'dyntask/api/tasks/show', :locals => { :task => @task }
      end

      private

      def find_task
        @task = Task.find_by_id(params[:id])
      end
    end
  end
end
