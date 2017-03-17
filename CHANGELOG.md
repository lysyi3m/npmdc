### 0.1.0

Initial implementation of Npmdc gem with following features:

* Checking for missed (or incorrectly installed) NPM dependencies inside specific folder

* Works with Ruby On Rails

* Standalone CLI tool


### 0.1.1

* Now works with Ruby >= 2.2.0


### 0.1.2

* Better messages - now with pluralization

* Better JSON parser errors - now with more details

* Fixed deprecated methods


### 0.2.0

Thanks to @aderyabin !

* Output formatters

* Colorized output

* Added specs

* Refactored and optimized


### 0.2.1

* Dropped ActiveSupport dependency for better compatibility


### 0.2.2

* Fixed runtime dependencies


### 0.2.3

Thanks to @palkan !

* Improved Rails integration

* Add Rails integration specs

* Minor improvements


### 0.2.4

* Fixed Rails integration

* Fixed options handling from config


### 0.2.5

Thanks to @aderyabin !

* Added new `types` option

* Added specs for 'short' formatter


### 0.3.0

* Added new version check functionality

* Added specs for version check


### 0.3.1

Thanks to @palkan !

* Added support for Ruby >= 2.1 and Rails 3.2


### 0.3.2

Thanks to @sponomarev !

* Added support for environment-based configuration


### 0.4.0

* Added support for "non-version" strings defined as packages version

* Added output warnings for unprocessable cases

Thanks to @sponomarev !

* Added `abort_on_failure` option


### 0.4.1

* Fixed unexpected behavior when `node_modules` contains extra folders w/o `package.json` file inside.
