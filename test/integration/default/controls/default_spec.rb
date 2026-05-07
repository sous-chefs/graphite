# frozen_string_literal: true

control 'graphite-config-01' do
  impact 1.0
  title 'Graphite configuration files are managed'

  describe file('/opt/graphite/conf/carbon.conf') do
    it { should exist }
    its('owner') { should eq 'graphite' }
    its('group') { should eq 'graphite' }
    its('mode') { should cmp '0644' }
    its('content') { should match(/\[cache\]/) }
    its('content') { should match(/LINE_RECEIVER_PORT = 2003/) }
  end

  describe file('/opt/graphite/conf/storage-schemas.conf') do
    it { should exist }
    its('content') { should match(/\[carbon\]/) }
    its('content') { should match(/RETENTIONS = 60:90d/) }
  end
end

control 'graphite-service-01' do
  impact 0.8
  title 'Carbon cache service is installed'

  describe systemd_service('carbon-cache') do
    it { should be_installed }
    it { should be_enabled }
  end
end
