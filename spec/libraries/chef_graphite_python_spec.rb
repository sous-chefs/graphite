require 'rspec'
require_relative '../../libraries/chef_graphite_python'

describe ChefGraphite::PythonWriter do
  let(:config) { Hash.new }
  let(:options) { Hash.new }
  let(:writer) { ChefGraphite::PythonWriter.new(config, options)}

  describe "#to_s" do
    it "take an empty config hash and returns and empty string" do
      expect(writer.to_s).to eq("\n")
    end

    it "takes a ruby hash and returns a string joined with new lines" do
      config["jazzhands"] = 100
      expect(writer.to_s).to eq("jazzhands = 100\n")
    end

    it "takes a ruby hash with multiple keys and returns a multiline string" do
      config["jazzhands"] = 100
      config["tapdance"] = 20
      expect(writer.to_s).to eq("jazzhands = 100\ntapdance = 20\n")
    end

    it "takes a hash and writes the python config" do
      config.replace({
          "secret_key" => "purplemonkeypants",
          "allowed_hosts" => [ '*' ],
          "time_zone" => "America/Los_Angeles",
          "documentation_url" => "https://myownprivatedocs.org",
          :log_rendering_performance => true,
          :log_cache_performance => true,
          :log_metric_access => true,
          'flushrrdcached' => 'unix:/var/run/rrdcached.sock',
          "whisper_dir" => '/opt/graphite/storage/whisper',
          :ldap_base_user => "CN=some_readonly_account,DC=mycompany,DC=com",
        })
      expect(writer.to_s).to eq(<<-EOF.gsub(/^\s+/, ''))
          secret_key = 'purplemonkeypants'
          allowed_hosts = ['*']
          time_zone = 'America/Los_Angeles'
          documentation_url = 'https://myownprivatedocs.org'
          log_rendering_performance = True
          log_cache_performance = True
          log_metric_access = True
          flushrrdcached = 'unix:/var/run/rrdcached.sock'
          whisper_dir = '/opt/graphite/storage/whisper'
          ldap_base_user = 'CN=some_readonly_account,DC=mycompany,DC=com'
       EOF
    end

    it "takes a hash and writes the python config with uppercase root keys" do
      options[:upcase_root_keys] = true
      config.replace({
          "secret_key" => "purplemonkeypants",
          "allowed_hosts" => [ '*' ],
          "time_zone" => "America/Los_Angeles",
          "documentation_url" => "https://myownprivatedocs.org",
          :log_rendering_performance => true,
          :log_cache_performance => true,
          :log_metric_access => true,
          'flushrrdcached' => 'unix:/var/run/rrdcached.sock',
          "whisper_dir" => '/opt/graphite/storage/whisper',
          :ldap_base_user => "CN=some_readonly_account,DC=mycompany,DC=com",
        })
      expect(writer.to_s).to eq(<<-EOF.gsub(/^\s+/, ''))
          SECRET_KEY = 'purplemonkeypants'
          ALLOWED_HOSTS = ['*']
          TIME_ZONE = 'America/Los_Angeles'
          DOCUMENTATION_URL = 'https://myownprivatedocs.org'
          LOG_RENDERING_PERFORMANCE = True
          LOG_CACHE_PERFORMANCE = True
          LOG_METRIC_ACCESS = True
          FLUSHRRDCACHED = 'unix:/var/run/rrdcached.sock'
          WHISPER_DIR = '/opt/graphite/storage/whisper'
          LDAP_BASE_USER = 'CN=some_readonly_account,DC=mycompany,DC=com'
       EOF
    end

  end
  describe "#pythonize" do

    it "renders a nil value as an empty string" do
      expect(writer.pythonize(nil)).to eq("''")
    end

    it "renders an integer as an integer" do
      expect(writer.pythonize(100).to_s).to eq("100")
    end

    it "renders a string value as a quoted string" do
      expect(writer.pythonize("purple:pants")).to eq("'purple:pants'")
    end

    it "renders false as False" do
      expect(writer.pythonize(false)).to eq("False")
    end

    it "renders true as True" do
      expect(writer.pythonize(true)).to eq("True")
    end

    it "renders an array of mixed elements as a quoted array of strings" do
      expect(writer.pythonize(["host:a", "100:b"])).
        to eq("['host:a', '100:b']")
    end

    it "renders a hash with integer values as a python dictionary" do
      expect(writer.pythonize("jazzhands" => 1)).
        to eq("{'jazzhands': 1}")
    end

    it "renders a hash with string values as a python dictionary" do
      expect(writer.pythonize("jazzhands" => "pants")).
        to eq("{'jazzhands': 'pants'}")
    end

    it "renders a hash with true values as a python dictionary" do
      expect(writer.pythonize("jazzhands" => true)).
        to eq("{'jazzhands': True}")
    end

    it "renders a hash with false values as a python dictionary" do
      expect(writer.pythonize("jazzhands" => false)).
        to eq("{'jazzhands': False}")
    end

    it "renders a hash with array values as a python dictionary" do
      expect(writer.pythonize("jazzhands" => ["tap", true, 100])).
        to eq("{'jazzhands': ['tap', True, 100]}")
    end

    it "renders a nested hash with mixed values" do
      expect(writer.pythonize(
          "jazzhands" => ["tap", true, 100],
          "tap" => { purple: 'pants' },
          "jazzercise" => false,
          "icedance" => 1)).to eq(
        "{'jazzhands': ['tap', True, 100], 'tap': {'purple': 'pants'}, 'jazzercise': False, 'icedance': 1}")
    end
  end

end
