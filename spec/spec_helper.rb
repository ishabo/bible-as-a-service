ENV['RACK_ENV'] = 'test'
require 'bundler/setup'
Bundler.require(:default, :test)

Mongoid.load!("./config/mongoid.yml", :test)
Dir["./app/routes/*.rb"].each {|file| require file }
Dir["./lib/helpers/*.rb"].each {|file| require file }
Dir["./lib/bible/*.rb"].each {|file| require file }
Dir["./lib/bible/versions/*.rb"].each {|file| require file }

MARANATHA = "ماران أثا"
METHUSELAH = "متوشالح"
GOD_IS_GOOD = "الرب صالح"
JESUS_OR_JOSHUA = "يسوع|يشوع"
MAHER_SHALAL_HASH_BAZ = "مهير شلال حاش بز"
FALSE_PROPHET = "محمد"
VERSIONS_DIR = './app/bible/versions'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:each) do
    $db = []
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end
