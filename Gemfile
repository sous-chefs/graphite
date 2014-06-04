# -*- mode: ruby -*-
# vi: set ft=ruby :
source 'https://rubygems.org'

gem 'rake'
gem 'librarian-chef'
gem 'emeril', :group => :release

group :development do
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
  gem 'guard-rspec'
end

group :style do
  gem 'rubocop', '~> 0.23'
  gem 'foodcritic', '~> 3.0'
end

group :test do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'kitchen-docker'
  gem 'chefspec', '~> 3.2.0'
end
