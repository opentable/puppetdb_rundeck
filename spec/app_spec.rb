require File.expand_path '../spec_helper.rb', __FILE__
require File.expand_path '../../lib/app.rb', __FILE__

describe 'puppetdb_rundeck Application' do
  it 'homepage should redirect to api page' do
    get '/'
    last_response.should be_redirect
    follow_redirect!
    last_request.url.should == 'http://example.org/api'
  end

  it 'should allow access to the main api page' do
    get '/api'
    last_response.should be_ok
    last_response.body.should include('Two API endpoints are provided')
  end

  it 'should allow access to the xml endpoint' do
    stub_request(:any, /puppetdb/).to_rack(FakePuppetDB)
    get '/api/xml'
    last_response.should be_ok
  end

  it 'should allow access to the yaml endpoint' do
    stub_request(:any, /puppetdb/).to_rack(FakePuppetDB)
    get '/api/yaml'
    last_response.should be_ok
  end
end