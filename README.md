# CramMd5

  unix_md5_crypt() provides a crypt()-compatible interface to the
  rather old MD5-based crypt() function found in modern operating systems
  using old and solid libs.

## Installation

Add this line to your application's Gemfile:

    gem 'cram_md5'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cram_md5

## Usage

  cryptedpassword = CramMd5::md5crypt_unix   (password [, salt [, magicstring ])

  apachepassword  = CramMd5::md5crypt_apache (password [, salt])

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
6. Execure the "THE BEER-WARE LICENSE".
