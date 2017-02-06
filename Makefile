corpus = lib/corpus/adjectives.bin lib/corpus/nouns.bin lib/corpus/adjectives-fixed.bin lib/corpus/nouns-fixed.bin

.PHONY: test

test: corpus
	ruby -Ilib tests.rb

gem: *.gem

publish: gem
	@ls -1 *gem
	@echo Press enter to publish gem. && read
	gem push *.gem

*.gem: corpus
	gem build spicy-proton.gemspec

corpus: $(corpus)

$(corpus): corpus/adjectives.yaml corpus/nouns.yaml
	ruby -Ilib corpus/generate.rb
