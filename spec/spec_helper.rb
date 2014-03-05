require 'chefspec'
require 'chefspec/librarian'

RSpec.configure do |config|
  config.log_level = :fatal
end

if ENV['COVERAGE']
  at_exit { ChefSpec::Coverage.report! }
end
