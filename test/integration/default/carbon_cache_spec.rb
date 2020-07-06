describe systemd_service('carbon-cache') do
  it { should be_enabled }
  it { should be_running }
end
