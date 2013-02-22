# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cram_md5/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thiago Coutinho"]
  gem.email         = ["thiago@osfeio.com"]
  gem.description   = %q{
  unix_md5_crypt() provides a crypt()-compatible interface to the
  rather old MD5-based crypt() function found in modern operating systems
  using old and solid libs.}
  gem.summary       = %q{ unix_md5_crypt CRAM-MD5 or Crypt MD5 }
  gem.homepage      = ""

  gem.files         = [
                        "Gemfile",
                        "LICENSE",
                        "README.md",
                        "Rakefile",
                        "cram_md5.gemspec",
                        "lib/cram_md5.rb",
                        "lib/cram_md5/version.rb"
                      ]

  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cram_md5"
  gem.require_paths = ["lib"]
  gem.version       = CramMd5::VERSION
end
