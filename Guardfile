# -*- mode: ruby -*-
# vi: set ft=ruby :

opts = "--color --format progress"

guard 'rspec', cmd: "bundle exec rspec #{opts}" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^(libraries|providers|recipes|resources)/(.+)\.rb$}) { |m| "spec/#{m[1]}/#{m[2]}_spec.rb" }
  watch("spec/spec_helper.rb")  { "spec" }
  watch(%r{^spec/fixtures/.+$}) { "spec" }
end
