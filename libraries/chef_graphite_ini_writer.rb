#
# Cookbook Name:: graphite
# Library:: ChefGraphite::INIWriter
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

  # Object that takes a specially formatted Hash and returns an INI-formatted
  # data representation as a String. Each key in the underlying Hash maps to a
  # top level INI section and each sub-Hash represents a set of key/value
  # pairs.
  #
  # @example hash input format
  #
  #   data = {
  #     :alpha => { "one" => "two" },
  #     "beta" -> { "three" => "four" }
  #   }
  #   writer = ChefGraphite::INIWriter.new(data).
  #   writer.to_s # => "[alpha]\none = two\n[beta]\nthree = four\n\n"
  #
  # @author Fletcher Nichol <fnichol@nichol.ca>
  #
  class INIWriter

    # Creates a new INIWriter using the provided Hash as input data.
    #
    # @param config [Hash,nil] input INI hash data
    #
    def initialize(config)
      @config = config || Hash.new
    end

    # Returns a string representing an INI document with section delimiters.
    #
    # @return [String] INI file string
    #
    def to_s
      lines = @config.map { |section, data| render_section(section, data) }
      lines.join("\n").concat("\n")
    end

    private

    # Returns a array of lines for a section of an INI file, including the
    # section header.
    #
    # @param section [String] name of the section
    # @param data [Hash] the set of key/value pairs for this section
    # @return [Array<String>] lines
    # @api private
    #
    def render_section(section, data)
      Array("[#{section}]").concat(
        data.map { |key, value| render_line(key, value) }
      )
    end

    # Returns a single key/value pair line of an INI file.
    #
    # @param key [#to_s] the key name
    # @param value [#to_s] the value
    # @return [String] the key/value line
    # @api private
    #
    def render_line(key, value)
      [key, value].join(" = ")
    end
  end
end
