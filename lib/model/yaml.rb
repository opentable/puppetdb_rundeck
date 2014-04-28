require File.expand_path('../../helpers/process', __FILE__)

class YAMLOutput
  attr_accessor :tmp_file

  def initialize(puppetdb_helper)
    @tmp_file = '/tmp/puppetdb-resource.yaml'
    @db_helper = puppetdb_helper
  end

  def parse
    nodes = @db_helper.get_nodes
    facts = @db_helper.get_facts
    helper = Helpers::Process.new

    rundeck_data = Hash.new
    nodes.each{|d|
      host = d['name']

      rundeck_data[host] = Hash.new if not rundeck_data.key?(host)

      rundeck_data = helper.add_facts(facts, host, rundeck_data)
    }

    yaml = rundeck_data.to_yaml

    File.open(@tmp_file, 'w') { |file| file.write(yaml) }

    return yaml
  end
end