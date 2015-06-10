require 'sinatra'
require 'rack/test'
require 'webmock/rspec'
require 'rspec/mocks'

require File.expand_path '../../spec/support/fake_puppetdb', __FILE__

WebMock.disable_net_connect!(:allow_localhost => true)

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  PuppetDBRunDeck.set :puppetdb_host, 'puppetdb'
  PuppetDBRunDeck.set :puppetdb_port, '8080'
  PuppetDBRunDeck.set :cache_timeout, 30
  PuppetDBRunDeck.set :thread_count, 3
  PuppetDBRunDeck
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.mock_with :rspec

  config.before(:all) do
    WebMock.disable_net_connect!(:allow_localhost => true)
  end
end
