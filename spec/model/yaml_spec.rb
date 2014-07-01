require File.expand_path '../../spec_helper.rb', __FILE__
require File.expand_path '../../../lib/helpers/puppetdb', __FILE__

describe EndPoint, '#to_yaml' do

  it 'should return valid yaml containing the node name' do
    helper = Helpers::PuppetDB.new('fubar', '80')
    allow(helper).to receive(:get_nodes).and_return([{'name' => 'test.internal'}])
    allow(helper).to receive(:get_facts).and_return([{'certname' => 'test.internal', 'name' => 'osfamily', 'value' => 'Debian'}])

    if File.exist?('/tmp/puppetdb-resource.yaml')
      FileUtils.rm '/tmp/puppetdb-resource.yaml'
    end

    endpoint = EndPoint.new(helper)

    expectation = "---\ntest.internal:\n  osfamily: Debian\n"

    endpoint.to_yaml().should == expectation
  end
end
