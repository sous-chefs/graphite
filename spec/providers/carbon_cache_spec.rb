require_relative '../spec_helper'
load_resource('graphite', 'carbon_cache')
load_provider('graphite', 'carbon_cache')

describe Chef::Provider::GraphiteCarbonCache do
  before { using_lw_resource('python', 'pip') }

  let(:resource_name) { 'wakka' }

  it 'is whyrun support' do
    expect(provider).to be_whyrun_supported
  end

  context 'for :create action' do
    let(:action) { :create }

    before { new_resource.action(action) }

    describe '#install_python_pip' do
      let(:resource) { provider.install_python_pip }

      it 'sets action to :install' do
        expect(resource.action).to eq([:install])
      end

      it 'sets name from backend attribute string' do
        new_resource.backend('shout')

        expect(resource.package_name).to eq('shout')
      end

      it 'sets name from backend attribute hash' do
        new_resource.backend('name' => 'scream')

        expect(resource.package_name).to eq('scream')
      end

      it 'sets package attributes from backend attribute hash' do
        new_resource.backend('name' => 'https://url.tar.gz', 'timeout' => 639)

        expect(resource.package_name).to eq('https://url.tar.gz')
        expect(resource.timeout).to eq(639)
      end
    end

    it 'adds python_pip to the resource collection' do
      provider.run_action(action)

      expect(runner_resources).to include('python_pip[whisper]')
    end
  end
end
