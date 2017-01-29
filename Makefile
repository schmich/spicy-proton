gem: *.gem

publish: gem
	gem push *.gem

*.gem: lib/corpus/combined.bin lib/corpus/*.yaml
	gem build spicy-proton.gemspec

lib/corpus/combined.bin: lib/corpus/*.yaml
	ruby -Ilib -rbinary -e 'Spicy::BinaryCorpus.generate'

test:
	ruby -Ilib test.rb
