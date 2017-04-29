cookbook_file '/etc/ssl/server.crt' do
  cookbook 'test'
  source   'server.crt'
end

cookbook_file '/etc/ssl/server.key' do
  cookbook 'test'
  source   'server.key'
end
