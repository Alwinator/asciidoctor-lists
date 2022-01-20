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
  s.summary = 'An asciidoctor extension that adds a list of figures, a list of tables, or a list of anything you want!'
  s.license = 'MIT'
  s.description = 'An asciidoctor extension that adds a list of figures, a list of tables, or a list of anything you want!'
  s.required_ruby_version = '>= 2.4.0'
  s.files = Dir['lib/**/*'] + ['README.adoc']
  s.add_runtime_dependency 'asciidoctor', '~> 2.0'
end