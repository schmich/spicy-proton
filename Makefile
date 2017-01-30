corpus = lib/corpus/adjectives.yaml lib/corpus/nouns.yaml lib/corpus/colors.yaml lib/corpus/adjectives.bin lib/corpus/nouns.bin lib/corpus/colors.bin  

.PHONY: test

test: corpus
	ruby -Ilib tests.rb

gem: *.gem

publish: gem
	gem push *.gem

*.gem: corpus
	gem build spicy-proton.gemspec

corpus: $(corpus)

$(corpus):
	ruby -Ilib corpus/generate.rb
