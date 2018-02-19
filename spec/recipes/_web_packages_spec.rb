require 'spec_helper'

describe 'graphite::_web_packages' do
  context 'on centos' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'centos', version: '7.3'
      ).converge(described_recipe)
    end

    it 'includes the yum-epel recipe' do
      expect(chef_run).to include_recipe('yum-epel')
    end
  end

  it 'installs system packages from an attribute' do
    node.set['graphite']['system_packages'] = %w(foo bar)

    expect(chef_run).to install_package('foo')
    expect(chef_run).to install_package('bar')
  end

  it 'installs a specific version of the django pip package' do
    node.set['graphite']['django_version'] = 'epoch'

    expect(chef_run).to install_python_pip('django').with(
      version: 'epoch'
    )
  end

  %w(django-tagging pytz pyparsing python-memcached uwsgi).each do |pkg|
    it "installs the #{pkg} pip package" do
      expect(chef_run).to install_python_pip(pkg)
    end
  end

  it 'installs a specific version of graphite_web from a package' do
    node.set['graphite']['install_type'] = 'package'
    node.set['graphite']['version'] = '9.8.7'

    expect(chef_run).to install_python_pip('graphite_web').with(
      package_name: 'graphite-web',
      version: '9.8.7'
    )
  end

  it 'installs graphite_web from a url source' do
    node.set['graphite']['install_type'] = 'source'
    node.set['graphite']['package_names']['graphite_web']['source'] = 'http://yep'

    expect(chef_run).to install_python_pip('graphite_web').with(
      package_name: 'http://yep',
      version: nil
    )
  end
end
