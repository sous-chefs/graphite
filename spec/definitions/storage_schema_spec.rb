require 'spec_helper'

describe 'graphite_storage_schema (definition)' do
  let(:recipe_run) do
    fake_recipe_run do
      graphite_storage_schema 'carbon' do
        config(
          pattern: '^carbon\.',
          retentions: '60:90d'
        )
      end

      graphite_storage_schema 'default_1min_for_1day' do
        config(
          pattern: '.*',
          retentions: '60s:1d'
        )
      end
    end
  end

  it 'creates carbon storage-schemas configuration' do
    expect(recipe_run).to render_file('storage-schemas.conf')
      .with_content([
        '[carbon]',
        'PATTERN = ^carbon\.',
        'RETENTIONS = 60:90d'
      ].join("\n"))
  end

  it 'creates more storage-schemas configuration' do
    expect(recipe_run).to render_file('storage-schemas.conf')
      .with_content([
        '[default_1min_for_1day]',
        'PATTERN = .*',
        'RETENTIONS = 60s:1d'
      ].join("\n"))
  end
end
