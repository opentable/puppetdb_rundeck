class XMLOutput
  attr_accessor :tmp_file

  def initialize(puppetdb_host, puppetdb_port)
    @tmp_file = '/tmp/puppetdb-resource.xml'
    @db_helper = Helpers::PuppetDB.new(puppetdb_host, puppetdb_port)
  end

  def parse
    nodes = @db_helper.get_nodes
    facts = @db_helper.get_all_facts

    rundeck_data = Array.new
    rundeck_data << "<project>\n"

    nodes.each{|d|
      host     = d['name']

      rundeck_data << "<node name=\"#{host}\" "

      rundeck_data = add_facts(facts, host, rundeck_data)

      rundeck_data << "/>\n"
    }

    rundeck_data << "</project>"
    xml = rundeck_data.join("\n")

    File.open(@tmp_file, 'w') { |file| file.write(xml) }

    return xml
  end
end