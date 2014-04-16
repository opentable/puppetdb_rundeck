require 'rubygems'
require 'net/http'
require 'uri'
require 'json'
require 'yaml'
require 'sinatra'
require 'haml'

require_relative 'helpers/puppetdb'
require_relative 'helpers/process'

require_relative 'model/endpoint'
require_relative 'model/xml'
require_relative 'model/yaml'

class PuppetDBRunDeck < Sinatra::Base
  get '/' do
    redirect to('/api')
  end

  get '/api' do
    haml :api
  end

  get '/api/yaml' do
    content_type 'text/yaml'
    output = YAMLOutput.new(settings.puppetdb_host, settings.puppetdb_port)
    endpoint_processor(output)
  end

  get '/api/xml' do
    content_type 'application/xml'
    output = XMLOutput.new(settings.puppetdb_host, settings.puppetdb_port)
    endpoint_processor(output)
  end
end