require 'seek'
require 'header'

module Spicy
end

module Spicy::Memory
  module Files
    def self.dir
      @@dir ||= File.join(File.dirname(__FILE__), 'corpus')
    end

    def self.adjectives
      @@adjectives ||= File.join(dir, 'adjectives.bin')
    end

    def self.nouns
      @@nouns ||= File.join(dir, 'nouns.bin')
    end
  end

  class WordList
    include Spicy::Seek

    def initialize(file_name)
      File.open(file_name, 'rb') do |r|
        @cumulative = Spicy::Header.cumulative(r)
        @min = @cumulative.keys.min
        @max = @cumulative.keys.max
        @words = r.read.split("\0")
      end
    end

    def word(*args)
      seek(*args) do |index|
        @words[index]
      end
    end
  end

  class Corpus
    def initialize
      dir = File.dirname(__FILE__)
      @adjectives = WordList.new(Files.adjectives)
      @nouns = WordList.new(Files.nouns)
    end

    def adjective(*args)
      @adjectives.word(*args)
    end

    def noun(*args)
      @nouns.word(*args)
    end

    def pair(separator = '-')
      "#{self.adjective}#{separator}#{self.noun}"
    end
  end
end
