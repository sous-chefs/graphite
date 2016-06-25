# -*- mode: ruby -*-
# vi: set ft=ruby :
source 'https://rubygems.org'

gem 'rake'
gem 'librarian-chef'
gem 'emeril', group: :release

group :development do
  gem 'guard-rspec'

end

group :style do
  gem 'inch'
  gem 'rubocop', '~> 0.40.0'
  gem 'foodcritic', '~> 6.0'
end

group :test do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'chefspec', '~> 3.3.0'
  gem 'kitchen-dokken'
end
