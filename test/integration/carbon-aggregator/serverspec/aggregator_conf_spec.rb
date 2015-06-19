require 'serverspec'
set :backend, :exec

describe 'Carbon daemon settings' do
  describe file('/opt/graphite/conf/carbon.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'graphite' }
    it { should be_grouped_into 'graphite' }
    it { should contain('# This file is managed by Chef') }
    it { should contain('[aggregator]') }
    [
      'LINE_RECEIVER_INTERFACE = 0.0.0.0',
      'LINE_RECEIVER_PORT = 2005',
      'REPLICATION_FACTOR = 1',
      'USE_FLOW_CONTROL = True',
      'RELAY_METHOD = consistent-hashing',
      'DESTINATIONS = 127.0.0.1:2003:a, 127.0.0.1:2004:b'
    ].each do |line|
      it { should contain(/^#{Regexp.escape(line)}$/).after(/^\[aggregator\]/) }
    end
  end
end
