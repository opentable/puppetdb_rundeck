require 'rubygems'
require 'yaml'
require 'json'
require 'sinatra'
require 'haml'

require File.expand_path('../helpers/puppetdb', __FILE__)
require File.expand_path('../helpers/process', __FILE__)

require File.expand_path('../model/endpoint', __FILE__)

class PuppetDBRunDeck < Sinatra::Base
  def initialize(app = nil, params = {})
    super(app)
    puppetdb_helper = Helpers::PuppetDB.new(settings.puppetdb_host, settings.puppetdb_port)
    @endpoint = EndPoint.new(puppetdb_helper, settings.cache_timeout, settings.thread_count)
  end

  get '/' do
    redirect to('/api')
  end

  get '/api' do
    haml :api
  end

  get '/api/yaml' do
    content_type 'text/yaml'
    content = @endpoint.to_yaml(true)
  end

  get '/api/xml' do
    content_type 'application/xml'
    content = @endpoint.to_xml(true)
  end

  get '/api/json' do
    content_type 'application/json'
    content = @endpoint.to_json(true)
  end

  get '/cache' do
    haml :cache
  end

  get '/cache/clear' do
    @endpoint.clear_cache
  end
end

# This allows app.rb to be run in isolation without the need for the executable
if (!defined? settings.puppetdb_host) and (!defined? settings.puppetdb_port)
  PuppetDBRunDeck.set :puppetdb_host, 'localhost'
  PuppetDBRunDeck.set :puppetdb_port, '8080'
end
