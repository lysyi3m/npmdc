[![Build Status](https://travis-ci.org/lysyi3m/npmdc.svg?branch=master)](https://travis-ci.org/lysyi3m/npmdc)
[![Code Climate](https://codeclimate.com/github/lysyi3m/npmdc/badges/gpa.svg)](https://codeclimate.com/github/lysyi3m/npmdc)
[![Gem Version](https://badge.fury.io/rb/npmdc.svg)](https://badge.fury.io/rb/npmdc)

npmdc
=========

![Screenshot](https://lysyi3m-pluto.s3.amazonaws.com/dropshare/Снимок-экрана-2016-12-06-в-10.27.02.png)


**NPM Dependency Checker** is a simple tool which can check for missed dependencies based on your `package.json` file.


<a href="https://evilmartians.com/?utm_source=npmdc">
  <img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54">
</a>

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
  config.npmdc.path   = "/path/to/your/frontend/code/dir" # `Rails.root` by default
  config.npmdc.format = "doc"                             # `short`, `doc`, `progress`. `short` by default
  config.npmdc.color  = false                             # `true` by default
end
```

### CLI tool:

```bash
$ bundle exec npmdc [options]

```

_Options:_

* --path PATH - Path to frontend code

* --color - Disable color formatting of output

* -f, --format FORMAT - Set format of output


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lysyi3m/npmdc.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
