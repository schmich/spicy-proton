corpus = lib/corpus/adjectives.bin lib/corpus/nouns.bin lib/corpus/adjectives-fixed.bin lib/corpus/nouns-fixed.bin lib/corpus/adverbs.bin lib/corpus/adverbs-fixed.bin lib/corpus/verbs.bin lib/corpus/verbs-fixed.bin

test: corpus
	ruby -Ilib tests.rb

irb:
	irb -Ilib -rspicy-proton

gem: *.gem

publish: gem
	@ls -1 *gem
	@echo Press enter to publish gem. && read
	gem push *.gem

*.gem: corpus
	gem build spicy-proton.gemspec

corpus: $(corpus)

$(corpus): corpus/adjectives.txt corpus/nouns.txt corpus/adverbs.txt corpus/verbs.txt
	ruby -Ilib corpus/generate.rb

.PHONY: test gem irb publish
