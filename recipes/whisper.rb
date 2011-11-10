remote_file "/usr/src/whisper-#{node.graphite.version}.tar.gz" do
  source node.graphite.whisper.uri
  checksum node.graphite.whisper.checksum
end

execute "untar whisper" do
  command "tar xzf whisper-#{node.graphite.version}.tar.gz"
  creates "/usr/src/whisper-#{node.graphite.version}"
  cwd "/usr/src"
end

execute "install whisper" do
  command "python setup.py install"
  creates "/usr/local/lib/python2.6/dist-packages/whisper-#{node.graphite.version}.egg-info"
  cwd "/usr/src/whisper-#{node.graphite.version}"
end
