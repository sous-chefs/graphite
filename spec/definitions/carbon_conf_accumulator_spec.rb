require 'spec_helper'

describe 'graphite_carbon_conf_accumulator (definition)' do
  let(:recipe_run) do
    fake_recipe_run do
      graphite_carbon_conf_accumulator 'default'
    end
  end

  it 'installs whisper' do
    expect(recipe_run).to install_python_pip('whisper')
  end

  context 'with a different backend' do
    let(:recipe_run) do
      fake_recipe_run do
        graphite_carbon_conf_accumulator 'default' do
          backend 'other_backend'
        end
      end
    end

    it 'installs the other backend' do
      expect(recipe_run).to install_python_pip('other_backend')
    end
  end

  context 'with backend attributes' do
    let(:recipe_run) do
      fake_recipe_run do
        graphite_carbon_conf_accumulator 'default' do
          backend(
            'name' => 'other_backend',
            'version' => '1.0.0'
          )
        end
      end
    end

    it 'installs the backend including the attributes' do
      expect(recipe_run).to install_python_pip('other_backend')
        .with_version('1.0.0')
    end
  end

  it 'creates carbon.conf file' do
    expect(recipe_run).to create_template('carbon.conf')
      .with_path('/opt/graphite/conf/carbon.conf')
      .with_cookbook('graphite')
      .with_source('carbon.conf.erb')
      .with_owner('graphite')
      .with_group('graphite')
      .with_mode(0644)
  end

  context 'with a delete action' do
    let(:recipe_run) do
      fake_recipe_run do
        graphite_carbon_conf_accumulator 'default' do
          action :delete
        end
      end
    end

    it 'delete the file template' do
      expect(recipe_run).to delete_template('carbon.conf')
    end

    it 'does not install whisper' do
      expect(recipe_run).to_not install_python_pip('whisper')
    end
  end

  context 'with configuation options' do
    let(:recipe_run) do
      fake_recipe_run do
        graphite_carbon_conf_accumulator 'default' do
          type :type
          config(
            option1: 'value1',
            option2: 'value2'
          )
        end
      end
    end

    it 'passes them to the template' do
      resource = recipe_run.template('carbon.conf')
      expect(resource.variables[:config]).to include(
        type: 'type',
        name: 'default',
        config: {
          option1: 'value1',
          option2: 'value2'
        }
      )
    end
  end
end
