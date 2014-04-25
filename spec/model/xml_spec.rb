require File.expand_path '../../spec_helper.rb', __FILE__
require File.expand_path '../../../lib/helpers/puppetdb', __FILE__
require File.expand_path '../../../lib/model/xml', __FILE__

describe XMLOutput, '#parse' do

  it 'should return valid xml containing the node name' do
    helper = Helpers::PuppetDB.new('fubar', '80')
    allow(helper).to receive(:get_nodes).and_return([{'name' => 'test.internal'}])
    allow(helper).to receive(:get_facts).and_return([{'certname' => 'test.internal', 'name' => 'osfamily', 'value' => 'Debian'}])

    xml_output = XMLOutput.new(helper)

    expectation = "<project>\n <node name=\"test.internal\" osfamily=\"Debian\"  />\n </project>"

    xml_output.parse.should == expectation
  end
end