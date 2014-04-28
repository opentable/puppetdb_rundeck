require 'rubygems'
require 'yaml'
require 'sinatra'
require 'haml'

require File.expand_path('../helpers/puppetdb', __FILE__)
require File.expand_path('../helpers/process', __FILE__)

require File.expand_path('../model/endpoint', __FILE__)
require File.expand_path('../model/xml', __FILE__)
require File.expand_path('../model/yaml', __FILE__)

class PuppetDBRunDeck < Sinatra::Base
  get '/' do
    redirect to('/api')
  end

  get '/api' do
    haml :api
  end

  get '/api/yaml' do
    content_type 'text/yaml'
    puppetdb_helper = Helpers::PuppetDB.new(settings.puppetdb_host, settings.puppetdb_port)
    output = YAMLOutput.new(puppetdb_helper)
    Helpers::Process.new().endpoint_processor(output)
  end

  get '/api/xml' do
    content_type 'application/xml'
    puppetdb_helper = Helpers::PuppetDB.new(settings.puppetdb_host, settings.puppetdb_port)
    output = XMLOutput.new(puppetdb_helper)
    Helpers::Process.new().endpoint_processor(output)
  end
end

# This allows app.rb to be run in isolation without the need for the executable
if (!defined? settings.puppetdb_host) and (!defined? settings.puppetdb_port)
  PuppetDBRunDeck.set :puppetdb_host, 'localhost'
  PuppetDBRunDeck.set :puppetdb_port, '8080'
end