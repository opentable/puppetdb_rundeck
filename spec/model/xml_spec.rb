require File.expand_path '../../spec_helper.rb', __FILE__
require File.expand_path '../../../lib/helpers/puppetdb', __FILE__

describe EndPoint, '#to_xml' do

  it 'should return valid xml containing the node name' do
    helper = Helpers::PuppetDB.new('fubar', '80')
    allow(helper).to receive(:get_nodes).and_return([{'name' => 'test.internal'}])
    allow(helper).to receive(:get_facts).and_return([{'certname' => 'test.internal', 'name' => 'osfamily', 'value' => 'Debian'}])

    if File.exist?('/tmp/puppetdb-resource.xml')
      FileUtils.rm '/tmp/puppetdb-resource.xml'
    end

    endpoint = EndPoint.new(helper)

    expectation = "<project>\n <node name=\"test.internal\" osfamily=\"Debian\" />\n </project>"

    endpoint.to_xml().should == expectation
  end
end
