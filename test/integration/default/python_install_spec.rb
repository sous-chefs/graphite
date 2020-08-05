describe directory('/var/lib/graphite/.pyenv') do
  it { should exist }
end

describe file('/opt/graphite/bin/python') do
  it { should be_executable }
  its(:owner) { should eq('graphite') }
end

describe command('/opt/graphite/bin/python --version') do
  its(:stdout) { should match(/3\.8\.5/) }
end
