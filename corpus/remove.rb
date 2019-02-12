require 'fileutils'

approved_words = File.readlines('approved.txt').collect(&:strip)

['adjectives', 'adverbs', 'nouns', 'verbs'].each do |item|
    original = File.readlines("original/#{item}.txt").collect(&:strip)
    File.open("#{item}.txt", 'w') do |out|
      out.puts original & approved_words
    end
end
