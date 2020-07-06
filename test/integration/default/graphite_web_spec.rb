describe systemd_service('graphite-web') do
  it { should be_enabled }
  it { should be_running }
end
