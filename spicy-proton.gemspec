Gem::Specification.new do |s|
  s.name = 'spicy-proton'
  s.version = (`git tag`.split("\n").last || '0.0.1').strip
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'Generate a random English adjective-noun word pair.'
  s.description = <<-END
    Generate a random English adjective-noun word pair. Includes random adjective
    and noun generation along with formatting and length constraints.
  END
  s.description = ''
  s.authors = ['Chris Schmich']
  s.email = 'schmch@gmail.com'
  s.files = Dir['lib/**/*.rb', 'lib/corpus/*.{yaml,bin}', '*.md', 'LICENSE']
  s.require_path = 'lib'
  s.homepage = 'https://github.com/schmich/spicy-proton'
  s.license = 'MIT'
  s.required_ruby_version = '>= 1.9.1'
  s.add_dependency 'bindata', '~> 2.3'
  s.add_development_dependency 'minitest', '~> 5.10'
end
