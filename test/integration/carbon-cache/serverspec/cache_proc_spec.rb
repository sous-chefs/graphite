require 'serverspec'
set :backend, :exec

describe 'Carbon cache daemon process' do
  describe process('carbon-cache.py') do
    it { should be_running }
  end

  %w(
    2004
    2005
    2006
    2007
    7003
    7004
  ).each do |tcp|
    describe port(tcp) do
      it { should be_listening.with('tcp') }
    end
  end # each tcp

  %w(
    2004
    2006
  ).each do |udp|
    describe port(udp) do
      it { should be_listening.with('udp') }
    end
  end # each udp
end
