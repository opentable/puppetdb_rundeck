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
        fact_endpoint = "http://#{@puppetdb_host}:#{@puppetdb_port}/v3/nodes/#{node}/facts"
      else
        fact_endpoint = "http://#{@puppetdb_host}:#{@puppetdb_port}/v3/facts"
      end

      #p "requesting facts by: #{fact_endpoint}"

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
