# SequentialFile

SequentialFile makes determination of which file to process easy!

It allows you to create files that are named sequentially *and* intelligently.

Files will have four primary parts in their filenames:

1. First part, which will be useful for list files in the shell.
2. Second part is a date stamp, which will be useful in not having unwanted junk in our globs.
3. Third part makes it easy to find the counter
4. Fourth part is the counter

## Installation

Add this line to your application's Gemfile:

    gem 'sequential_file'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequential_file

## Usage

For now see the specs.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
