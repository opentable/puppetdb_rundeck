     # PuppetDBRundeck

puppetdb_rundeck is a sinatra based application to provide integration between [PuppetDB](https://docs.puppetlabs.com/puppetdb/latest/) and [Rundeck](http://rundeck.org/).
It provides an api in either xml or yaml that allows the node and fact data with puppetdb to use used as a resource
with rundeck.

## Installation

Install it yourself as:

    $ gem install puppetdb_rundeck

## Usage

Start the application:

    $ puppetdb_rundeck --pdbhost <puppetdb hostname> --pdbport <puppetdb port> --port <application port>

Then go to the following endpoint in your browser:

    http://localhost:<port>/api

## Contributing

1. Fork it ( http://github.com/opentable/puppetdb_rundeck/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
