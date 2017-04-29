cookbook_file '/etc/ssl/server.crt' do
  cookbook 'graphite_example'
  source   'server.crt'
end

cookbook_file '/etc/ssl/server.key' do
  cookbook 'graphite_example'
  source   'server.key'
end
