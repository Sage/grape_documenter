# GrapeDoc

This adds a rake tasks to Rails Applications to generate documentation for Grape APIs.

## Installation

Add this line to your application's Gemfile:

    gem 'grape_doc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grape_doc

## Usage

Within the root of you Rails Application run the following rake task...

   $ bundle exec rake generate_grape_docs['MyApplication::API','/path/to/where/you/want/your/docs']

NOTE: The lack of space between the arguments. Rake doesn't like the space unless you wrap the whole thing as a string.

The first argument is the a string of the class of Grape::API. If you have multiple APIs within the same application you can run the rake task as many times as you like with different output paths.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
