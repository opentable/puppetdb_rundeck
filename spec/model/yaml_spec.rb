require File.expand_path '../../spec_helper.rb', __FILE__
require File.expand_path '../../../lib/helpers/puppetdb', __FILE__
require File.expand_path '../../../lib/model/yaml', __FILE__

describe YAMLOutput, '#parse' do

  it 'should return valid yaml containing the node name' do
    helper = Helpers::PuppetDB.new('fubar', '80')
    allow(helper).to receive(:get_nodes).and_return([{'name' => 'test.internal'}])
    allow(helper).to receive(:get_facts).and_return([{'certname' => 'test.internal', 'name' => 'osfamily', 'value' => 'Debian'}])

    yaml_output = YAMLOutput.new(helper)

    expectation = "---\ntest.internal:\n  osfamily: Debian\n"

    yaml_output.parse.should == expectation
  end
end