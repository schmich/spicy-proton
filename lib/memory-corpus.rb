require 'yaml'
require 'securerandom'

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
    def initialize(file_name)
      dataset = YAML.load_file(file_name)

      @words = dataset['words']
      @cumulative = dataset['cumulative']

      @min = @cumulative.keys.min
      @max = @cumulative.keys.max
    end

    def word(min: nil, max: nil)
      raise RangeError.new('min must be no more than max') if !min.nil? && !max.nil? && min > max

      min = [min || @min, @min].max
      max = [max || @max, @max].min

      rand_min = @cumulative[min - 1] || 0
      rand_max = @cumulative[max] || @cumulative[@max]
      index = SecureRandom.random_number(rand_min...rand_max)

      min.upto(max) do |i|
        if @cumulative[i] > index
          index -= (@cumulative[i - 1] || 0)
          return @words[i][index]
        end
      end

      nil
    end
  end

  class Corpus
    def initialize
      dir = File.dirname(__FILE__)
      @adjectives = WordList.new(Files.adjectives)
      @nouns = WordList.new(Files.nouns)
      @colors = WordList.new(Files.colors)
    end

    def adjective(min: nil, max: nil)
      @adjectives.word(min: min, max: max)
    end

    def noun(min: nil, max: nil)
      @nouns.word(min: min, max: max)
    end

    def color(min: nil, max: nil)
      @colors.word(min: min, max: max)
    end

    def pair(separator = '-')
      "#{self.adjective}#{separator}#{self.noun}"
    end
  end
end
