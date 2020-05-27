describe port(2003) do
  it { should be_listening }
  its('protocols') { should include 'udp' }
end

[2003, 2004, 7002].each do |p|
  describe port(p) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end
end

describe port(8080) do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end

describe command('curl -fs http://localhost:8080/metrics/find?query=carbon.*') do
  its(:exit_status) { should eq(0) }
end
