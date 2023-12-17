# frozen_string_literal: true

require_relative 'lib/teal_toad/version'

Gem::Specification.new do |s|
  s.name        = 'teal_toad'
  s.version     = TealToad::VERSION
  s.summary     = 'TealToad is a data science and machine learning library.'
  s.description = 'TealToad is a data science and machine learning library written in Ruby.'
  s.licenses    = ['Apache-2.0']
  s.required_ruby_version = '3.0.0'

  s.authors     = ['Marco Donna']
  s.email       = 'm.donna03@gmail.com'

  s.files = Dir['README.md', 'Gemfile', 'lib/**/*.rb']

  s.homepage    = 'https://github.com/MarcoDonna/TealToad'
  s.metadata    = { 'source_code_uri' => 'https://github.com/MarcoDonna/TealToad',
                    'rubygems_mfa_required' => 'true' }
end
