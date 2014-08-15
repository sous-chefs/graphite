#
# Cookbook Name:: graphite
# Library:: ChefGraphite::CarbonConfigConverter
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

module ChefGraphite

  # Converts an Array of resource-like Ruby Hashes and converts the collection
  # into a sorted Hash data structure suitable for serializing into an INI
  # format.
  #
  # @example converting resource-like data
  #
  #   data = [
  #     { type: "cache", name: "a", config: {"aa" => "bb"} },
  #     { type: "relay", name: "default", config: {} },
  #     { type: "aggregator", name: "primary", config: {} }
  #   ]
  #   converter = ChefGraphite::CarbonConfigConverter.new(data)
  #   converter.to_hash
  #   # => {"aggregator:primary"=>{}, "cache:a"=>{"aa"=>"bb"}, "relay"=>{}}
  #
  # @author Fletcher Nichol <fnichol@nichol.ca>
  #
  class CarbonConfigConverter

    # Creates a new CarbonConfigConverter using the provided Array of Hashes
    # as input data.
    #
    # @param config [Array<Hash>] input dataset
    #
    def initialize(config)
      @config = Array(config)
    end

    # Returns a sorted Hash data structure where each key is a section and
    # each sub-Hash is a set of related key/value pairs.
    #
    # @return [Hash] the converted hash
    #
    def to_hash
      Hash[sort_tuples(section_tuples)]
    end

    private

    # Sorts an Array of tuples by the first element in the each tuple.
    #
    # @param tuples [Array<Array>] an Array of 2-element arrays
    # @return [Array<Array>] a sorted Array of tuples
    # @api private
    #
    def sort_tuples(tuples)
      tuples.sort { |a, b| a.first <=> b.first }
    end

    # Returns an Array of tuples-the first element being the name of the
    # section and the last element being a Hash of key/value pairs.
    #
    # @return [Array<Array>] an Array of 2-element arrays
    # @api private
    #
    def section_tuples
      @config.map do |hash|
        [section_name(hash[:type], hash[:name]), normalize(hash[:config])]
      end
    end

    # Computes the name of a section given an optional type and a name.
    #
    # @param type [String,nil] a type of thing
    # @param name [String] a primary name of the thing
    # @return [String] the section name
    # @api private
    #
    def section_name(type, name)
      if type.nil?
        name
      elsif name == "default"
        type
      else
        "#{type}:#{name}"
      end
    end

    # Traverses a Hash and normalizes each key and value for a format suitable
    # to creating carbon.conf and other graphite-related configuration files.
    #
    # @param hash [Hash]
    # @return [Hash] a new, normalized Hash
    # @api private
    #
    def normalize(hash)
      result = Hash.new
      hash.each do |key, value|
        result[key.to_s.upcase] = normalize_value(value)
      end
      result
    end

    # Normalizes an object and returns a String value suitable for creating
    # carbon.conf and other graphite-related configuration files.
    #
    # @param obj [Object]
    # @return [String] a String value
    # @api private
    #
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
