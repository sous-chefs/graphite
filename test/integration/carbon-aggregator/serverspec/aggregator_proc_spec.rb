require 'serverspec'
set :backend, :exec

describe 'Carbon aggregator daemon process' do
  describe process('carbon-aggregator.py') do
    it { should be_running }
  end

  %w(
    2004
    2005
  ).each do |tcp|
    describe port(tcp) do
      it { should be_listening.with('tcp') }
    end
  end # each tcp
end
