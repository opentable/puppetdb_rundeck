require 'uri'
require 'net/http'
require 'json'

module Helpers
  class PuppetDB

    def initialize(host, port, api_version)
      @puppetdb_host = host
      @puppetdb_port = port
      @api_version = api_version
      if api_version == 3
        @base_url = "http://#{@puppetdb_host}:#{@puppetdb_port}/v3"
      elsif api_version == 4
        @base_url = "http://#{@puppetdb_host}:#{@puppetdb_port}/pdb/query/v4"
      else
        raise "Unknown version"
      end
    end

    def get_nodes
      uri = URI.parse( "#{@base_url}/nodes" )
      request = Net::HTTP::Get.new(uri.path)
      request.add_field('Accept', 'application/json')
      http_client = Net::HTTP.new(uri.host, uri.port)
      response = http_client.request(request)
      response['Content-Type'] = 'application/yaml'
      if response.code == '200'
        nodes = JSON.parse(response.body)
      else
        nodes = []
      end

      return nodes
    end

    def get_facts(node=nil)
      if node
        fact_endpoint = "#{@base_url}/nodes/#{node}/facts"
      else
        fact_endpoint = "#{@base_url}/facts"
      end
      
      uri = URI.parse(fact_endpoint)
      request = Net::HTTP::Get.new(uri.path)
      request.add_field('Accept', 'application/json')
      http_client = Net::HTTP.new(uri.host, uri.port)
      begin
        response = http_client.request(request)
        response['Content-Type'] = 'application/json'
        if response.code == '200'
          facts = JSON.parse(response.body)
        else
          facts = []
        end

        return facts
      rescue Timeout::Error

      end
    end

  end
end
