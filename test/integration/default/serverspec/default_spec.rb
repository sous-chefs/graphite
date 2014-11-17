require 'serverspec'
set :backend, :exec

describe 'carbon-cache' do
  describe port(2003) do
    it { should be_listening.with('udp') }
  end

  [ 2003, 2004, 7002 ].each do |p|
    describe port(p) do
      it { should be_listening.with('tcp') }
    end
  end
end

describe 'graphite-web' do
  describe port(8080) do
    it { should be_listening.with('tcp') }
  end
end
