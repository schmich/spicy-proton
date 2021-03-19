Gem::Specification.new do |s|
  s.name = 'spicy-proton'
  s.version = `git tag`.split("\n").map { |v| Gem::Version.new(v) }.sort.last.to_s.strip
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'Generate a random English adjective-noun word pair.'
  s.description = <<-END
    Generate a random English adjective-noun word pair. Includes random adjective,
    noun, adverb, and verb generation along with formatting and length constraints.
  END
  s.description = ''
  s.authors = ['Chris Schmich']
  s.email = 'schmch@gmail.com'
  s.files = Dir['lib/**/*.rb', 'lib/corpus/*.bin', '*.md', 'LICENSE']
  s.require_path = 'lib'
  s.homepage = 'https://github.com/schmich/spicy-proton'
  s.license = 'MIT'
  s.required_ruby_version = '>= 1.9.1'
  s.add_dependency 'bindata', '~> 2.3'
  s.add_development_dependency 'minitest', '~> 5.10'
end
