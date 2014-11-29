#
# Cookbook Name:: graphite
# Library:: ChefSpec matchers
#
# Copyright 2014, Heavy Water Ops, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if defined?(ChefSpec)
  def create_graphite_storage(name)
    ChefSpec::Matchers::ResourceMatcher.new(:graphite_storage, :create, name)
  end

  def delete_graphite_storage(name)
    ChefSpec::Matchers::ResourceMatcher.new(:graphite_storage, :delete, name)
  end

  def create_graphite_carbon_conf_accumulator(name)
    ChefSpec::Matchers::ResourceMatcher.new(:graphite_carbon_conf_accumulator, :create, name)
  end

  def enable_runit_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:runit_service, :enable, resource_name)
  end
end
