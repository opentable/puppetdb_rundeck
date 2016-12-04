require 'uri'
require 'net/http'
require 'json'

module Helpers
  class PuppetDB

    def initialize(host, port, api_version)
      @puppetdb_host = host
      @puppetdb_port = port
      @api_version = api_version.to_s
      @api_endpoint = case @api_version
                      when '3'
                        'v3'
                      when '4'
                        'pdb/query/v4'
                      else
                        raise "Unknown version"
                      end
      @base_url = "http://#{@puppetdb_host}:#{@puppetdb_port}/#{@api_endpoint}"
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
      nodes.each{|node| node['name'] ||= node['certname']}

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
