require 'bundler/setup'
require 'sapwood'
require 'faker'

require 'dotenv/load'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    Sapwood.configure do |conf|
      conf.api_url = ENV['SAPWOOD_API_URL']
      conf.key = nil
      conf.property_id = nil
      conf.token = nil
    end
  end
end
