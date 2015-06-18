require 'spec_helper'

describe 'graphite_storage_conf_accumulator (definition)' do
  let(:recipe_run) do
    fake_recipe_run do
      graphite_storage_conf_accumulator 'default'
    end
  end

  it 'creates storage-schemas.conf file' do
    expect(recipe_run).to create_template('storage-schemas.conf')
      .with_path('/opt/graphite/conf/storage-schemas.conf')
      .with_cookbook('graphite')
      .with_source('carbon.conf.erb')
      .with_owner('graphite')
      .with_group('graphite')
      .with_mode(0644)
  end

  it 'does not create an empty [default] entry (avoids no retentions error)' do
    expect(recipe_run).to_not render_file('storage-schemas.conf')
      .with_content('[default]')
  end

  context 'with a delete action' do
    let(:recipe_run) do
      fake_recipe_run do
        graphite_storage_conf_accumulator 'default' do
          action :delete
        end
      end
    end

    it 'delete the file template' do
      expect(recipe_run).to delete_template('storage-schemas.conf')
    end
  end

  context 'with configuation options' do
    let(:recipe_run) do
      fake_recipe_run do
        graphite_storage_conf_accumulator 'default' do
          type :type
          config option1: 'value1', option2: 'value2'
        end
      end
    end

    it 'passes them to the template' do
      resource = recipe_run.template('storage-schemas.conf')
      expect(resource.variables[:config]).to include(
        name: 'default',
        config: {
          option1: 'value1',
          option2: 'value2'
        }
      )
    end
  end
end
