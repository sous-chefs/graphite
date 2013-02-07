template "/etc/init.d/carbon-cache" do
  source "carbon.init.erb"
end

service "carbon-cache" do
end
