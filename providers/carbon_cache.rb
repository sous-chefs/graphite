def whyrun_supported?
  true
end

use_inline_resources

action :create do
  p = python_pip package_name do
    package_attributes.each { |attr, value| send(attr, value) }
  end
  Chef::Log.info "Installing storage backend: #{package_name}"
  new_resource.updated_by_last_action(p.updated_by_last_action?)
end

private

def package_name
  backend = new_resource.backend
  backend.is_a? Hash ? backend["name"] : backend
end

def package_attributes
  backend = new_resource.backend
  if backend.is_a? Hash
    attrs = backend.dup
    attrs.delete("name")
    attrs
  else
    Hash.new
  end
end
