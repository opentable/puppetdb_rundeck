require File.expand_path '../../spec_helper.rb', __FILE__
require File.expand_path '../../../lib/helpers/puppetdb.rb', __FILE__

describe Helpers::PuppetDB, '#get_nodes' do

  it 'should return json when puppetdb details are valid' do

    stub_request(:get, 'http://localhost:8080/v3/nodes').
        with(:headers => {'Accept'=>['*/*', 'application/json'], 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => '{ "name" : "test.internal" }', :headers => {})

    puppetdb = Helpers::PuppetDB.new('localhost', '8080')
    nodes = puppetdb.get_nodes
    nodes.should_not be_empty
  end

  it 'should return an empty collection when the details are invalid' do

    stub_request(:get, 'http://fubar:8080/v3/nodes').
        with(:headers => {'Accept'=>['*/*', 'application/json'], 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 404, :body => '', :headers => {})

    puppetdb = Helpers::PuppetDB.new('fubar', '8080')
    nodes = puppetdb.get_nodes
    nodes.should be_empty
  end

end

describe Helpers::PuppetDB, '#get_facts' do

  it 'should return json when puppetdb details are valid' do

    stub_request(:get, 'http://localhost:8080/v3/facts').
        with(:headers => {'Accept'=>['*/*', 'application/json'], 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => '{ "name" : "osfamily" }', :headers => {})

    puppetdb = Helpers::PuppetDB.new('localhost', '8080')
    nodes = puppetdb.get_facts
    nodes.should_not be_empty
  end

  it 'should return an empty collection when the details are invalid' do

    stub_request(:get, 'http://fubar:8080/v3/facts').
        with(:headers => {'Accept'=>['*/*', 'application/json'], 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 404, :body => '', :headers => {})

    puppetdb = Helpers::PuppetDB.new('fubar', '8080')
    nodes = puppetdb.get_facts
    nodes.should be_empty
  end
end