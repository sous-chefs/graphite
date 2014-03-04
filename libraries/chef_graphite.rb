module ChefGraphite
  class << self

    def ini_file(resources)
      data = generate_conf_data(resources_to_hashes(resources))

      lines = []
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

    def resources_to_hashes(resources)
      Array(resources).map do |resource|
        {
          :type => resource.resource_name.to_s.split("_").last,
          :name => resource.name,
          :config => resource.config
        }
      end
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
      name == "default" ? type : "#{type}:#{name}"
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
