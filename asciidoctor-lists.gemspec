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
  s.files = Dir['lib/**/*'] + ['README.adoc']
  s.add_runtime_dependency 'asciidoctor', '~> 2.0'
end