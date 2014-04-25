require 'sinatra/base'

class FakePuppetDB < Sinatra::Base

  get '/v3/nodes' do
    '[{ "name": "test-node-01" }]'
  end

  get '/v3/facts' do
    '[{ "certname": "test-node-01", "name": "osfamily", "value": "Debian" }]'
  end
end