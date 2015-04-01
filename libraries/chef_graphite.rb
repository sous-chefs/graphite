#
# Cookbook Name:: graphite
# Library:: ChefGraphite
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

module ChefGraphite
  class << self

    def ini_file(hash)
      data = generate_conf_data(hash)

      lines = Array.new
      data.each do |section, config|
        lines << "[#{section}]"
        config.each { |key, value| lines << "#{key} = #{value}" }
        lines << ""
      end
      lines.join("\n").concat("\n")
    end

    def generate_conf_data(data)
      tuples = sort_tuples(section_tuples(data))

      result = Hash.new
      tuples.each { |tuple| result[tuple.first] = tuple.last }
      result
    end

    def sort_tuples(tuples)
      tuples.sort { |a, b| a.first <=> b.first }
    end

    def section_tuples(section_hashes)
      section_hashes.map do |hash|
        [
          section_name(hash[:type], hash[:name]),
          normalize(hash[:config])
        ]
      end
    end

    def section_name(type, name)
      if type.nil?
        name
      elsif name == "default"
        type
      else
        "#{type}:#{name}"
      end
    end

    def normalize(hash)
      result = Hash.new
      hash.each do |key, value|
        result[key.to_s.upcase] = normalize_value(value)
      end
      result
    end

    def normalize_value(obj)
      if obj.is_a? Array
        obj.map { |o| normalize_value(o) }.join(", ")
      else
        value = obj.to_s
        value.capitalize! if %w{true false}.include?(value)
        value
      end
    end
  end
end
