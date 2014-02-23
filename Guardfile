# -*- mode: ruby -*-
# vi: set ft=ruby :

opts = "--color --format progress"

guard 'rspec', cmd: "bundle exec rspec #{opts}" do
  watch(%r{^spec/.+$})
  watch(%r{^test/fixtures/cookbooks/.+$})
  %w{resources providers recipes}.each do |w|
    watch(%r{^#{w}/(.+)\.rb$})     { |m| "spec/#{w}/#{m[1]}_spec.rb" }
  end
end
