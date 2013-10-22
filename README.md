# GrapeDocumenter
[![travis-ci](https://secure.travis-ci.org/Sage/grape_documenter.png)](http://travis-ci.org/#!/Sage/grape_documenter)
[![Dependency Status](https://gemnasium.com/Sage/grape_documenter.png)](https://gemnasium.com/Sage/grape_documenter)
[![Code Climate](https://codeclimate.com/github/Sage/grape_documenter.png)](https://codeclimate.com/github/Sage/grape_documenter)

This adds a task to Rails Applications to generate documentation for [Grape](https://github.com/intridea/grape) APIs.

## Installation

Add this line to your application's Gemfile:

    gem 'grape_documenter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grape_documenter

## Usage

Within the root of you Rails Application run the following rake task...

    $ bundle exec grape_documenter 'MyApp::Api' '/path/to/docs' --format='html' --mounted-path='/api'

The first argument is the a string of the class of Grape::API. If you have multiple APIs within the same application you can run the task as many times as you like with different output paths.

### Specifying output format

Currently 2 formats are supported: 'html'; 'textile'. The default is html. You can change the format as shown above.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Verify that all tests pass (`bundle exec fudge build`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
