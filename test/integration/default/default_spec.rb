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

describe http('http://localhost:8080/metrics/find?query=carbon.*', enable_remote_worker: true) do
  its('status') { should cmp 200 }
end
