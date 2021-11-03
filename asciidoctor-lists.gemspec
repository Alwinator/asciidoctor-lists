begin
  require_relative 'lib/asciidoctor-lists/version'
rescue LoadError
  require 'asciidoctor-lists/version'
end

Gem::Specification.new do |s|
  s.name = 'asciidoctor-lists'
  s.version = AsciidoctorLists::VERSION
  s.authors = ['Alwin Schuster']
  s.homepage = 'https://github.com/Alwinator/asciidoctor-lists'
  s.summary = 'An Asciidoctor extension that adds bibtex integration to AsciiDoc'
  s.license = 'MIT'
  s.description = 'Adds lists'
  s.required_ruby_version = '>= 2.4.0'
  s.files = Dir['lib/**/*'] + ['LICENSE.txt', 'README.adoc']
  s.add_runtime_dependency 'asciidoctor', '~> 2.0'
  s.add_runtime_dependency 'bibtex-ruby', '~> 5.1'
  s.add_runtime_dependency 'citeproc-ruby', '~> 1'
  s.add_runtime_dependency 'csl-styles', '~> 1'
  s.add_runtime_dependency 'latex-decode', '~> 0.2'

  s.add_development_dependency 'minitest', '~> 5.11.0'
  s.add_development_dependency 'rake', '~> 12.3.0'
end