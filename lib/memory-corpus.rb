require 'yaml'
require 'seek'

module Spicy
end

module Spicy::Memory
  module Files
    def self.dir
      @@dir ||= File.join(File.dirname(__FILE__), 'corpus')
    end

    def self.adjectives
      @@adjectives ||= File.join(dir, 'adjectives.yaml')
    end

    def self.nouns
      @@nouns ||= File.join(dir, 'nouns.yaml')
    end

    def self.colors
      @@colors ||= File.join(dir, 'colors.yaml')
    end
  end

  class WordList
    include Spicy::Seek

    def initialize(file_name)
      dataset = YAML.load_file(file_name)

      @words = dataset['words']
      @cumulative = dataset['cumulative']

      @min = @cumulative.keys.min
      @max = @cumulative.keys.max
    end

    def word(*args)
      self.seek(*args) do |index, length|
        index -= (@cumulative[length - 1] || 0)
        @words[length][index]
      end
    end
  end

  class Corpus
    def initialize
      dir = File.dirname(__FILE__)
      @adjectives = WordList.new(Files.adjectives)
      @nouns = WordList.new(Files.nouns)
      @colors = WordList.new(Files.colors)
    end

    def adjective(*args)
      @adjectives.word(*args)
    end

    def noun(*args)
      @nouns.word(*args)
    end

    def color(*args)
      @colors.word(*args)
    end

    def pair(separator = '-')
      "#{self.adjective}#{separator}#{self.noun}"
    end
  end
end
