template "/etc/init.d/carbon" do
  source "carbon.init.erb"
end

service "carbon-cache" do
end
