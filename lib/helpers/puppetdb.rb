require 'uri'
require 'net/http'
require 'json'

module Helpers
  class PuppetDB

    def initialize(host, port)
      @puppetdb_host = host
      @puppetdb_port = port
    end

    def get_nodes
      uri = URI.parse( "http://#{@puppetdb_host}:#{@puppetdb_port}/v3/nodes" )
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path)
      request.add_field('Accept', 'application/json')
      response = http.request(request)
      response['Content-Type'] = 'application/yaml'
      if response.code == '200'
        nodes = JSON.parse(response.body)
      else
        nodes = []
      end

      return nodes
    end

    def get_facts
      uri = URI.parse( "http://#{@puppetdb_host}:#{@puppetdb_port}/v3/facts" )
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path)
      request.add_field('Accept', 'application/json')
      response = http.request(request)
      response['Content-Type'] = 'application/yaml'
      if response.code == '200'
        facts = JSON.parse(response.body)
      else
        facts = []
      end

      return facts
    end

  end
end
