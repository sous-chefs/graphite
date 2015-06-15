require 'serverspec'
set :backend, :exec

describe 'Carbon daemon settings' do
  describe file('/opt/graphite/conf/carbon.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'graphite' }
    it { should be_grouped_into 'graphite' }
    it { should contain('# This file is managed by Chef') }
    it { should contain('[cache]') }
    [
      'ENABLE_LOGROTATION = True',
      'USER = graphite',
      'MAX_CACHE_SIZE = inf',
      'MAX_UPDATES_PER_SECOND = 500',
      'MAX_CREATES_PER_MINUTE = 50',
      'LINE_RECEIVER_INTERFACE = 0.0.0.0',
      'LINE_RECEIVER_PORT = 2003',
      'UDP_RECEIVER_PORT = 2003',
      'PICKLE_RECEIVER_PORT = 2004',
      'ENABLE_UDP_LISTENER = True',
      'CACHE_QUERY_PORT = 7002',
      'CACHE_WRITE_STRATEGY = sorted',
      'USE_FLOW_CONTROL = True',
      'LOG_UPDATES = False',
      'LOG_CACHE_HITS = False',
      'WHISPER_AUTOFLUSH = False'
    ].each do |line|
      it { should contain(/^#{Regexp.escape(line)}$/).after(/^\[cache\]/) }
    end
    it { should contain('[cache:a]') }
    [
      'LINE_RECEIVER_PORT = 2004',
      'UDP_RECEIVER_PORT = 2004',
      'PICKLE_RECEIVER_PORT = 2005',
      'CACHE_QUERY_PORT = 7003'
    ].each do |line|
      it { should contain(/^#{Regexp.escape(line)}$/).after(/^\[cache:a\]/) }
    end
    it { should contain('[cache:b]') }
    [
      'LINE_RECEIVER_PORT = 2006',
      'UDP_RECEIVER_PORT = 2006',
      'PICKLE_RECEIVER_PORT = 2007',
      'CACHE_QUERY_PORT = 7004'
    ].each do |line|
      it { should contain(/^#{Regexp.escape(line)}$/).after(/^\[cache:b\]/) }
    end
  end
end
