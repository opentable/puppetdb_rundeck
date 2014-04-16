class YAMLOutput
  attr_accessor :tmp_file

  def initialize(puppetdb_host, puppetdb_port)
    @tmp_file = '/tmp/puppetdb-resource.yaml'
    @db_helper = Helpers::PuppetDB.new(puppetdb_host, puppetdb_port)
  end

  def parse
    nodes = @db_helper.get_nodes
    facts = @db_helper.get_all_facts

    rundeck_data = Hash.new
    nodes.each{|d|
      host     = d['name']

      rundeck_data[host] = Hash.new if not rundeck_data.key?(host)

      rundeck_data = add_facts(facts, host, rundeck_data)
    }

    yaml = rundeck_data.to_yaml

    File.open(@tmp_file, 'w') { |file| file.write(yaml) }

    return yaml
  end
end