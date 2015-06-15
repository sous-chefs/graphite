require 'serverspec'
set :backend, :exec

describe 'Carbon relay daemon process' do
  describe process('carbon-relay.py') do
    it { should be_running }
  end

  %w(
    2003
    2004
  ).each do |tcp|
    describe port(tcp) do
      it { should be_listening.with('tcp') }
    end
  end # each tcp
end
