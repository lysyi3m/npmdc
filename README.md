[![Build Status](https://travis-ci.org/lysyi3m/npmdc.svg?branch=master)](https://travis-ci.org/lysyi3m/npmdc)
[![Gem Version](https://badge.fury.io/rb/npmdc.svg)](https://badge.fury.io/rb/npmdc)

npmdc
=========

**NPM Dependency Checker** is a simple tool which can check for missed dependencies based on your `package.json` file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'npmdc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install npmdc

## Usage

### Rails

```ruby
YourApp::Application.configure do
  config.npmdc = {
    :path => "/path/to/your/frontend/code/dir" # `Rails.root` by default,
    :verbose => true                           # `false` by default
  }
end
```

### CLI tool:

```bash
$ bundle exec npmdc --path="/path/to/your/frontend/code/dir" --verbose

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lysyi3m/npmdc.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
