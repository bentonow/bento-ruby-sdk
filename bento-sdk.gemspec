require File.expand_path('../lib/bento/sdk/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name = 'bento-sdk'
  spec.version = '0.1.0'
  spec.files = Dir.glob("{lib,bin}/**/*")
  spec.require_paths = ['lib']
  spec.summary = 'Bento Ruby SDK and tracking library'
  spec.description = 'The Bentonow.com ruby analytics library'
  spec.authors = ['Bentonow.com']
  spec.email = 'support@Bentonow.com'
  spec.homepage = 'https://github.com/bentonow/ruby-sdk'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.0'

  # Used in the executable testing script
  spec.add_development_dependency 'commander', '~> 4.4'

  # Used in specs
  spec.add_development_dependency 'rake', '~> 10.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'tzinfo', '1.2.1'
  spec.add_development_dependency 'activesupport', '~> 4.1.11'

  if RUBY_VERSION >= '2.0' && RUBY_PLATFORM != 'java'
    spec.add_development_dependency 'oj', '~> 3.6.2'
  end

  if RUBY_VERSION >= '2.1'
    spec.add_development_dependency 'rubocop', '~> 0.51.0'
  end
  
  spec.add_development_dependency 'codecov', '~> 0.1.4'
end
