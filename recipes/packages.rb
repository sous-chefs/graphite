#
# Cookbook Name:: graphite
# Recipe:: packages
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

dep_packages = case node['platform_family']
               when 'debian'
                 packages = %w{ python-cairo-dev python-django python-django-tagging python-rrdtool }

                 # Optionally include memcached client
                 if node['graphite']['web']['memcached_hosts'].length > 0
                   packages += %w{python-memcache}
                 end
                 
                 if node['graphite']['web']['ldap']['SERVER'].length > 0
                   packages += %w{python-ldap}
                 end

                 packages
               when 'rhel', 'fedora'
                 packages = %w{ Django django-tagging pycairo-devel python-devel mod_wsgi python-sqlite2 python-zope-interface }

                 # Include bitmap packages (optionally)
                 if node['graphite']['web']['bitmap_support']
                   if node['platform'] == 'amazon'
                     packages += %w{bitmap}
                   else
                     packages += %w{bitmap bitmap-fonts}
                   end
                 end

                 # Optionally include memcached client
                 if node['graphite']['web']['memcached_hosts'].length > 0
                   packages += %w{python-memcached}
                 end
                 
                 if node['graphite']['web']['ldap']['SERVER'].length > 0
                   packages += %w{python-ldap}
                 end

                 packages
               end

dep_packages.each do |pkg|
  package pkg do
    action :install
  end
end
