require_relative '../helpers/process'

class XMLOutput
  attr_accessor :tmp_file
  attr_accessor :db_helper

  def initialize(puppetdb_helper)
    @tmp_file = '/tmp/puppetdb-resource.xml'
    @db_helper = puppetdb_helper
  end

  def parse
    nodes = @db_helper.get_nodes
    facts = @db_helper.get_facts
    helper = Helpers::Process.new

    rundeck_data = Array.new
    rundeck_data << "<project>\n"

    nodes.each{|n|
      host = n['name']

      rundeck_data << "<node name=\"#{host}\""

      rundeck_data = helper.add_facts(facts, host, rundeck_data)

      rundeck_data << "/>\n"
    }

    rundeck_data << "</project>"
    xml = rundeck_data.join(" ")

    File.open(@tmp_file, 'w') { |file| file.write(xml) }

    return xml
  end
end