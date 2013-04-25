if node['graphite']['create_user']
  group node['graphite']['group_account'] do
    system true
    action :create
  end
  user node['graphite']['user_account'] do
    system true
    group node['graphite']['group_account']
    home "/var/lib/graphite"
    shell "/bin/none"
    action :create
  end
end
