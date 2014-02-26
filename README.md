# sequential_file

Sequential File makes determination of which file to process (read or write) easy!

| Project                 |  Sequential File   |
|------------------------ | ----------------- |
| gem name                |  sequential_file   |
| license                 |  MIT              |
| moldiness               |  [![Maintainer Status](http://stillmaintained.com/pboling/sequential_file.png)](http://stillmaintained.com/pboling/sequential_file) |
| version                 |  [![Gem Version](https://badge.fury.io/rb/sequential_file.png)](http://badge.fury.io/rb/sequential_file) |
| dependencies            |  [![Dependency Status](https://gemnasium.com/pboling/sequential_file.png)](https://gemnasium.com/pboling/sequential_file) |
| code quality            |  [![Code Climate](https://codeclimate.com/github/pboling/sequential_file.png)](https://codeclimate.com/github/pboling/sequential_file) |
| continuous integration  |  [![Build Status](https://secure.travis-ci.org/pboling/sequential_file.png?branch=master)](https://travis-ci.org/pboling/sequential_file) |
| test coverage           |  [![Coverage Status](https://coveralls.io/repos/pboling/sequential_file/badge.png)](https://coveralls.io/r/pboling/sequential_file) |
| homepage                |  [https://github.com/pboling/sequential_file][homepage] |
| documentation           |  [http://rdoc.info/github/pboling/sequential_file/frames][documentation] |
| author                  |  [Peter Boling](https://coderbits.com/pboling) |
| Spread ~♡ⓛⓞⓥⓔ♡~      |  [![Endorse Me](https://api.coderwall.com/pboling/endorsecount.png)](http://coderwall.com/pboling) |

## Summary

It allows you to create files that are named sequentially *and* intelligently.

Files will have four primary parts in their filenames:

1. First part, which will be useful for list files in the shell.
2. Second part is a date stamp, which will be useful in not having unwanted junk in our globs.
3. Third part makes it easy to find the counter
4. Fourth part is the counter

## Compatibility

Tested with Ruby 2.0.0+.  Due to the use of Ruby's 'prepend' initialization feature, will not work with anything older.

There are no dependencies, gem or otherwise, this is a pure Ruby library, and will work with any sort of File-type class.

## Installation

Add this line to your application's Gemfile:

    gem 'sequential_file'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequential_file

## Usage

If you have your own File-like class then you may just need to use the SequentialFile::Namer by including it.

```
class MyFileLikeThing
    include SequentialFile::Namer
end
```

This gem ships with a reference implementation of a File-wrapper class that uses the Namer to determine which file to process.

Have a look at `lib/sequential_file/base.rb` or require it and play with it:

```
require 'sequential_file/base'

file = SequentialFile::Base.new({
                           directory_path: '/tmp',
                           name: 'access_log.FileBase.csv',
                           process_date: Date.today
                         })

file.write('this is new text')          # => write ensures that the file is open for writing, but you have to remember to close!
file.close
file.write('this is after close text')
file.read =~ /this is after close text/ # => integer representation of the position in the file where the text match starts
file.close
```

Also, see the specs.

## Contributors

See the [Network View](https://github.com/pboling/sequential_file/network) and the [CHANGELOG](https://github.com/pboling/sequential_file/blob/master/CHANGELOG.md)

## How you can help!

Take a look at the `reek` and `roodi` lists. These are the files names `REEK` and `ROODI` in the root of the gem.

Currently they are clean, and we like to keep them that way!  Once you complete a change, run the tests:

```
bundle exec rake spec
```

If the tests pass refresh the `reek` and `roodi` lists and make sure things have not gotten worse:

```
bundle exec rake reek > REEK
bundle exec rake reek > ROODI
```

Follow the instructions for "Contributing" below.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver].
Violations of this scheme should be reported as bugs. Specifically,
if a minor or patch version is released that breaks backward
compatibility, a new version should be immediately released that
restores compatibility. Breaking changes to the public API will
only be introduced with new major versions.

As a result of this policy, you can (and should) specify a
dependency on this gem using the [Pessimistic Version Constraint][pvc] with two digits of precision.

For example:

    spec.add_dependency 'sequential_file', '~> 1.0.8'

## Legal

* MIT License - See LICENSE file in this project
* Copyright (c) 2014 [Peter H. Boling][peterboling] of [Rails Bling][railsbling]

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74
[railsbling]: http://www.railsbling.com
[peterboling]: http://www.peterboling.com
[documentation]: http://rdoc.info/github/pboling/sequential_file/frames
[homepage]: https://github.com/pboling/sequential_file


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/pboling/sequential_file/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
