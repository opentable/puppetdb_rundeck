
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
      request.add_field("Accept", "application/json")
      response = http.request(request)
      response["Content-Type"] = "application/yaml"
      return JSON.parse(response.body)
    end

    def get_all_facts
      uri = URI.parse( "http://#{@puppetdb_host}:#{@puppetdb_port}/v3/facts" )
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path)
      request.add_field("Accept", "application/json")
      response = http.request(request)
      response["Content-Type"] = "application/yaml"
      return JSON.parse(response.body)
    end

  end
end
