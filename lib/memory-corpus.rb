require 'seek'
require 'header'
require 'corpus'

module Spicy
end

module Spicy::Memory
  module Files
    @@files = {}

    def self.dir
      @@dir ||= File.join(File.dirname(__FILE__), 'corpus')
    end

    def self.corpus(type)
      @@files[type] ||= File.join(dir, "#{type}.bin")
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

    def words
      @words
    end
  end

  class Corpus
    include Spicy::Corpus

    def initialize
      @lists = {}
    end

    def adjectives
      list(:adjectives).words
    end

    def nouns
      list(:nouns).words
    end

    def adverbs
      list(:adverbs).words
    end

    def verbs
      list(:verbs).words
    end

    private

    def generate(type, *args)
      list(type).word(*args)
    end

    def list(type)
      @lists[type] ||= begin
        WordList.new(Files.corpus(type))
      end
    end
  end
end
