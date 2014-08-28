#
# Cookbook Name:: graphite
# Provider:: provider_storage_conf_accumulator
#
# Copyright 2014, Heavy Water Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# nod to https://github.com/kisoku/chef-accumulator for the ideas

require 'chef/provider'

class Chef
  class Provider
    class GraphiteStorageConfAccumulator < Chef::Provider

      include ChefGraphite::Mixins

      def whyrun_supported?
        false
      end

      def load_current_resource
        @current_resource = new_resource
      end

      def action_create
        resources = run_context.resource_collection.select { |x| x.resource_name == :graphite_storage_schema }
        file_resource = run_context.resource_collection.find(new_resource.file_resource)

        contents = "# This file is managed by Chef, your changes *will* be overwritten!\n\n"
        contents << ChefGraphite.ini_file(resources_to_hashes(resources))
        file_resource.content contents

        file_resource.run_action(:create)

        if file_resource.updated_by_last_action?
          new_resource.updated_by_last_action(true)
        end

      end
    end
  end
end
