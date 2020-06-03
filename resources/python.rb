default_action :install

property :pyenv_name, String, name_property: true
property :python_version, String, default: '2.7.17'
property :user, String, default: lazy { node['graphite']['user'] }
property :graphite_dir, String, default: lazy { node['graphite']['base_dir'] }

action :install do
  pyenv_user_install new_resource.pyenv_name do
    user new_resource.user
  end

  pyenv_python new_resource.python_version do
    user new_resource.user
  end

  pyenv_global new_resource.python_version do
    user new_resource.user
  end

  pyenv_pip 'virtualenv' do
    user new_resource.user
  end

  pyenv_script 'setup graphite virtualenv' do
    code "virtualenv #{new_resource.graphite_dir}"
    user new_resource.user
  end
end
